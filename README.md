# Raffle Smart Contract

## Overview

**Raffle** is a smart contract designed to create a decentralized raffle system on the Ethereum blockchain. It utilizes Chainlink's Verifiable Random Function (VRF) to ensure fair and random winner selection. This project is built using the Foundry toolkit, which provides a fast and modular environment for Ethereum application development.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contract Structure](#contract-structure)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Decentralized Raffle**: Participants can enter the raffle by sending Ether.
- **Random Winner Selection**: Uses Chainlink VRF for secure and verifiable randomness.
- **Event Logging**: Emits events for key actions like entering the raffle and picking a winner.
- **Easy Deployment**: Simple deployment scripts included.

## Installation

To get started with the Raffle smart contract, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/raffle.git
   cd raffle
   ```

2. **Initialize submodules**:
   ```bash
   git submodule update --init --recursive
   ```

3. **Install Foundry**:
   Ensure you have Foundry installed. If not, you can install it by following the instructions on the [Foundry documentation](https://book.getfoundry.sh/).

4. **Install dependencies**:
   ```bash
   forge install
   ```

## Usage

### Build the Contract

To compile the smart contract, run:
```bash
forge build
```

### Run Tests

To execute the tests, use:
```bash
forge test
```

### Deploy the Contract

To deploy the contract, you can use the following command:
```bash
forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Enter the Raffle

Participants can enter the raffle by sending Ether to the `enterRaffle` function. Ensure that the amount sent is greater than or equal to the entrance fee.

## Contract Structure

The Raffle contract is structured as follows:

- **State Variables**: Holds the entrance fee, players, and raffle state.
- **Functions**:
  - `enterRaffle()`: Allows users to enter the raffle.
  - `checkUpKeep()`: Checks if the conditions to pick a winner are met.
  - `performUpkeep()`: Executes the winner selection process.
  - `fulfillRandomWords()`: Handles the random number returned by Chainlink VRF.

## Testing

The project includes tests to ensure the functionality of the smart contract. You can add more tests in the `test` directory to cover additional scenarios.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Foundry](https://book.getfoundry.sh/) for the development toolkit.
- [Chainlink](https://chain.link/) for the VRF service.
