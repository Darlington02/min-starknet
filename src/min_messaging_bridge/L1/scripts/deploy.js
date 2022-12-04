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
    "0xde29d060D45901Fb19ED6C6e959EB22d8626708e", //core contract
    "0x04d103053e58567b01fa01600094daa59286029d391832f4d4b68172503b7ace", // L2 contract address
    "0x9F7D1801163902A50C168f310691FdC97C346395" //bridge admin address

  );

  // Deploying the ERC20
  const ERC20 = await ethers.getContractFactory("MinStarknet");
  const erc20 = await ERC20.deploy(
    bridge.address //bridge contract address
  );

  console.log("Token Bridge smart contract address:", bridge.address);
  console.log("ERC20 smart contract address:", erc20.address);

  // const data = {
  //   address: bridge.address,
  //   abi: JSON.parse(stake.interface.format("json")),
  // };

  // if (!fs.existsSync("artifacts/ABI")) fs.mkdirSync("artifacts/ABI");
  // fs.writeFileSync("artifacts/ABI/TokenBridge.json", JSON.stringify(data), {
  //   flag: "w",
  // });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });