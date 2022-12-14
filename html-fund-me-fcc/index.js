import { ethers } from "./ethers-5.2.esm.min.js";
import { abi, contractAddress } from "./constants.js";

const connectButton = document.getElementById("connectButton");
const fundButton = document.getElementById("fundButton");

connectButton.onclick = connect;
fundButton.onclick = fund;

//to connect wallet
async function connect() {
  if (typeof window.ethereum !== "undefined") {
    await window.ethereum.request({ method: "eth_requestAccounts" });
    connectButton.innerHTML = "Connected";
  } else {
    alert("Please Install MetaMask!");
  }
}

//return wallet's balance
async function getBalance() {
  if (window.ethereum !== "undefined") {
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
  }
}
//fund to contract
async function fund() {
  const ethAmount = document.getElementById("ethAmount").value;
  console.log(`funding ${ethAmount} ...`);
  if (typeof window.ethereum !== "undefined") {
    // provider / connection to the blockchain
    const provider = new ethers.providers.Web3Provider(window.ethereum);

    //signer / wallet / someone with some gas
    const signer = provider.getSigner();

    //contact -> ABI & Address
    const contract = new ethers.Contract(contractAddress, abi, signer);

    try {
      //calling fund func from cotract
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      });
      //wait for this transaction to finish
      await listenForTransactionMine(transactionResponse, provider);
      console.log("Process completed!");
    } catch (error) {
      console.log(error);
    }
  }
}

//event listner
function listenForTransactionMine(transactionResponse, provider) {
  console.log(`Mining ${transactionResponse.hash} ...`);
  //create listener for the blockchain
  return new Promise((resolve, reject) => {
    provider.once(transactionResponse.hash, (transactionReciept) => {
      console.log(
        `Completed with ${transactionReciept.confirmations} confirmations`
      );
      resolve();
    });
  });
}
