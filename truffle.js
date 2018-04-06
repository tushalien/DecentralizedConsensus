require('babel-register')
var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/GT650Dz4fUm2eSgLUfX8")
      },
      network_id: 3,
      gas: 4600000
    },
  	development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 4600000// Match any network id
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/GT650Dz4fUm2eSgLUfX8")
      },
      network_id: 4,
      gas: 4600000
    }   
  }
};