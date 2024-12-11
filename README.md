# A Fair Smart Contract Raffle

A decentralized and automated raffle system built on blockchain technology, utilizing Chainlink VRF for verifiable randomness and Chainlink Automation for trustless execution.

## Overview

This project implements a fully automated raffle system where:
- Users can enter by paying a set entrance fee
- A winner is automatically and fairly selected at regular intervals
- Uses Chainlink VRF (Verifiable Random Function) for provably fair winner selection
- Leverages Chainlink Automation for automatic draws
- Implements a robust testing suite

## Features

- **Fair Entry System**: Fixed entrance fee required to participate
- **Automated Execution**: No manual intervention needed for picking winners
- **Verifiable Randomness**: Chainlink VRF v2.5 ensures provably fair winner selection
- **Time-Based Draws**: Configurable intervals between raffles
- **Transparent**: Fully verifiable on-chain logic
- **State Management**: Proper handling of raffle states (OPEN and CALCULATING)
- **Gas Efficient**: Optimized for minimal gas consumption

## Technical Details

### Contract Architecture

The project consists of several key contracts:

- `Raffle.sol`: Main contract implementing the raffle logic
- `DeployRaffle.s.sol`: Script for deploying the raffle
- `HelperConfig.s.sol`: Configuration management for different networks
- `Interactions.s.sol`: Helper scripts for contract interactions

### Key Dependencies

- Solidity ^0.8.19
- Chainlink VRF V2.5
- Forge/Foundry for testing and deployment
- Solmate for optimized contract implementations

### Testing

Comprehensive test suite available in `test/unit/RaffleTest.t.sol`, covering:
- Initialization states
- Entry conditions
- Player recording
- Event emissions
- State transitions
- Upkeep checks
- Winner selection

## Getting Started

### Prerequisites

- Foundry installed
- Node.js and npm (for additional tooling)
- An RPC URL for deployment
- LINK tokens for VRF funding (on mainnet/testnet)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd raffle-contract
```

2. Install dependencies:
```bash
forge install
```

3. Compile contracts:
```bash
forge build
```

4. Run tests:
```bash
forge test
```

### Deployment

1. Set up your environment variables:
```bash
cp .env.example .env
# Fill in your environment variables
```

2. Deploy to a network:
```bash
forge script script/DeployRaffle.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

## Usage

### Entering the Raffle

Users can enter the raffle by calling the `enterRaffle()` function with the required entrance fee:

```solidity
raffle.enterRaffle{value: entranceFee}()
```

### Checking Raffle Status

Several view functions are available:
- `getEntranceFee()`: Get the required entrance fee
- `getRaffleState()`: Check if raffle is OPEN or CALCULATING
- `getPlayer(uint256 index)`: Get player at specific index
- `getNumberOfPlayers()`: Get total number of players

## Security Considerations

- Implements CEI (Checks-Effects-Interactions) pattern
- Uses custom errors for gas efficiency
- Proper access control mechanisms
- Comprehensive error handling
- VRF v2.5 for secure randomness

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Saksham Gupta

## Acknowledgments

- Chainlink VRF team for randomness solution
- Foundry team for development framework
