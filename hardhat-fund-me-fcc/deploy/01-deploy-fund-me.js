//import

function deployFunc() {
  console.log("Hardhat Deployment");
}

// module.exports = async (hre) => {
//     const {getNamedAccounts,deployment} = hre;
// };

//Syntactic sugar
module.exports = async ({ getNamedAccounts, deployment }) => {
  const { deploy, log } = deployment;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;
};
