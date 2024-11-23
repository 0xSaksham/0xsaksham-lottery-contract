// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A Raffle Contract
 * @author Saksham Gupta
 * @notice This contract for creating a sample raffle
 * @dev Implements Chainlink VRF v2.5
 */
abstract contract Raffle is VRFConsumerBaseV2Plus {
    /*Errors */
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__TransferFailed();
    error Raffle__UpKeepNotNeeded(
        uint256 currentBalance,
        uint256 numPlayers,
        uint RaffleState
    );

    /* Type Declarations */
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    /* State Variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    /* Events */
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not Enough ETH sent"); Highly Gas Expensive due to storage in string
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        // require(msg.value >= i_entranceFee, Raffle__SendMoreToEnterRaffle); this works with highly specific solidity versions and more expensive than the used one
        s_players.push(payable(msg.sender)); // everytime you use storage variable, use events: WHY? See below
        // 1. Makes Migration easier
        // 2. Makes front end "indexing" easier
        emit RaffleEntered(msg.sender);
    }

    /**
     * @dev This is the function that the ChainLink Keeper nodes call
     * they look for 'upKeepNeeded' to return True.
     * the following should be true for this to return true:
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is the open state.
     * 3. The contract has ETH.
     * 4. Implicitly, your subscription is funded with LINK.
     */

    function checkUpKeep(
        bytes memory /* checkData */
    ) public view returns (bool upKeepNeeded, bytes memory /* performData */) {
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool timePassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool hasPlayers = s_players.length > 0;
        bool hasBalance = address(this).balance > 0;

        upKeepNeeded = isOpen && timePassed && hasPlayers && hasBalance;
        return (upKeepNeeded, "0x0");
    }

    // 1. Get a random number ✅
    // 2. Use the generated random number to pick winner ✅
    // 3. Call the pickWinner again after the lottery closes (typical part as smart contracts are not easily automated!)
    function performUpkeep(bytes calldata /* performData */) external {
        // check to see if enough time has passed!
        (bool upKeepNeeded, ) = checkUpKeep("");
        if (!upKeepNeeded) {
            revert Raffle__UpKeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }

        // Get our random number from Chainlink VRF
        // 1. Request RNG
        // 2. Get RNG
        s_raffleState = RaffleState.CALCULATING;

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });

        s_vrfCoordinator.requestRandomWords(request);
    }

    // CEI: Checks, Effects, Interactions Pattern
    function fulfillRandomWords(
        uint256, //requestId,
        uint256[] calldata randomWords
    ) internal virtual override {
        // Checks

        // Effects (Internal Contract State)
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");

        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        emit WinnerPicked(s_recentWinner);

        // Interactions (External Contract Interactions)
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /**
     * Getter Functions
     */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
