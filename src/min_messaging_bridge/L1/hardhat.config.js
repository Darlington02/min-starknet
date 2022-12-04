require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: "./.env" });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000000,
      },
    },
  },
  networks: {
    myNetwork: {
      url: "http://localhost:5000",
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_URL}`,
      accounts: [`0x${process.env.PRIVATE_KEY}`],
    },
  },
};
