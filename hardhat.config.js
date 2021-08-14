require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config()

const ALCHEMY_ROPSTEN_API_KEY = process.env.ALCHEMY_ROPSTEN_API_KEY
const ROPSTEN_PRIVATE_KEY = process.env.ROPSTEN_PRIVATE_KEY
const ALCHEMY_RINKEBY_API_KEY = process.env.ALCHEMY_RINKEBY_API_KEY
const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY
const ALCHEMY_MAINNET_API_KEY = process.env.ALCHEMY_MAINNET_API_KEY
const MAINNET_PRIVATE_KEY = process.env.MAINNET_PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

module.exports = {
  solidity: "0.8.6",
  gasReporter: {
    currency: 'USD',
    gasPrice: 38
  },
  networks: {
	  hardhat: {
	    chainId: 1337,
      blockGasLimit: 30000000
	  },
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_ROPSTEN_API_KEY}`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_RINKEBY_API_KEY}`,
      accounts: [`0x${RINKEBY_PRIVATE_KEY}`],
    },
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_MAINNET_API_KEY}`,
      accounts: [`0x${MAINNET_PRIVATE_KEY}`],
    },
 },
 etherscan: {
  apiKey: ETHERSCAN_API_KEY
  }
};

