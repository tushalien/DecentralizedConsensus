var Migrations = artifacts.require("./Migrations.sol");
var Freelancer = artifacts.require("./Freelancer.sol")
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Freelancer);
};
