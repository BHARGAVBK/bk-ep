const { ethers } = require("hardhat");
const { expect, assert } = require("chai");
//describe("SimpleStorage", function () {})
describe("SimpleStorage", function () {
  let SimpleStorageFactory, simpleStorage;
  beforeEach(async () => {
    SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage");
    simpleStorage = await SimpleStorageFactory.deploy();
  });

  it("Should start with the favorite number of 0", async () => {
    const currentValue = await simpleStorage.retrieve();
    const expectedValue = "0";
    //assert
    //expect
    assert.equal(currentValue.toString(), expectedValue);
  });
  it("Should update when called", async () => {
    const expectedValue = "7";
    const transactionResponse = await simpleStorage.store(expectedValue);
    await transactionResponse.wait(1);

    const currentValue = await simpleStorage.retrieve();
    assert.equal(currentValue.toString(), expectedValue);
  });
  it("Should display starting value 0", async () => {
    const expectedValue = "0";
    const globalFav = await simpleStorage.favNumber;

    assert(globalFav.toString(), expectedValue);
  });
  it("Should update globalFav when called", async () => {
    const expectedValue = "99";
    const transactionResponse = await simpleStorage.setGlobalFavNum(
      expectedValue
    );
    transactionResponse.wait(1);

    const currentValue = await simpleStorage.favNumber;

    assert(currentValue.toString(), expectedValue);
  });
});
