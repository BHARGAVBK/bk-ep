// imports
const { ethers, run, network } = require("hardhat");

// async main
async function main() {
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage");

  console.log("Deploying conrtact ....");

  const simpleStorage = await SimpleStorageFactory.deploy();
  await simpleStorage.deployed();

  console.log(`Contract deployed to: ${simpleStorage.address}`);

  if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
    await simpleStorage.deployTransaction.wait(5);
    await verify(simpleStorage.address, []);
  }

  //retrieve current value from contract
  const currentValue = await simpleStorage.retrieve();
  console.log(`Current Value: ${currentValue}`);

  //update current value
  const transactionResponse = await simpleStorage.store("77");
  await transactionResponse.wait(1);
  const updatedValue = await simpleStorage.retrieve();
  console.log(`Updated Current value: ${updatedValue}`);
}

async function verify(contractAddress, args) {
  try {
    console.log("Verifying Contract ....");
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified Contract");
    } else {
      console.log(`Error Occured in Verification: ${e}`);
    }
  }
}

// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
