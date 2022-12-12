const fs = require("fs");
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  // deploying the token bridge contract
  const TokenBridge = await ethers.getContractFactory("ERC20Bridge");
  //Passing Starknet core contract address and Stake L2 address
  const bridge = await TokenBridge.deploy(
    "0xa4eD3aD27c294565cB0DCc993BDdCC75432D498c", //core contract for goerli2
    "0x04d103053e58567b01fa01600094daa59286029d391832f4d4b68172503b7ace", // L2 contract address
    "0x9F7D1801163902A50C168f310691FdC97C346395" //bridge admin address

  );

  // Deploying the ERC20
  const ERC20 = await ethers.getContractFactory("MinStarknet");
  const erc20 = await ERC20.deploy(
    bridge.address //bridge contract address
  );

  // Deploying the Token Bridge contract
  console.log("Token Bridge smart contract address:", bridge.address);
  console.log("ERC20 smart contract address:", erc20.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });