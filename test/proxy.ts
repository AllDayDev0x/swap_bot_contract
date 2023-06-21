import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Proxy", () => {
    const deployTestContract = async () => {
        const [owner] = await ethers.getSigners()

        const Test = await ethers.getContractFactory("Test");
        const TestContract = await Test.deploy();
        return { TestContract, owner };
    }

    const deployProxyContract = async () => {
        const [owner] = await ethers.getSigners();
        const ProxyFactory = await ethers.getContractFactory("Proxy");
        const ProxyContract = await ProxyFactory.deploy();
        return { ProxyContract, owner };
    }

    describe("Test execute method", () => {
        it("get encrypt from address", async () => {
            const { ProxyContract, owner } = await deployProxyContract();
            const { TestContract, } = await deployTestContract();
            const tx = await TestContract.connect(owner).populateTransaction.setSender();
            console.log(tx)
            console.log('Proxy Contract Address =>', ProxyContract.address);
            expect(await ProxyContract.connect(owner).execute(TestContract.address, tx.data!)).emit(ProxyContract, "Up")
            expect(await ProxyContract.connect(owner).execute(TestContract.address,tx.data!)).to.emit(TestContract, "UpdatedSendder");
            const sender = await TestContract.sender();
            console.log(sender, owner.address);
        });

      
    })
})