import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Encrypt", () => {
    const privateKey = ethers.utils.hexlify(ethers.utils.randomBytes(32));
    const provider = new ethers.providers.JsonRpcBatchProvider();
    const publicKey =  new ethers.Wallet(privateKey).address;
    console.log("publicKey", publicKey)
    const deployEncryptContract = async () => {
        const [owner] = await ethers.getSigners()
        const signer = await ethers.getSigner(publicKey);

        console.log(await signer.getBalance())
        const Encrypt = await ethers.getContractFactory("Encrypt");
        const encryptContract = await Encrypt.deploy();
        console.log(owner.getBalance())
        return { encryptContract, owner };
    }

    describe("Read methods", () => {
        it("get encrypt from address", async () => {
            const { encryptContract, owner } = await loadFixture(deployEncryptContract);
            const encryptedValue = await encryptContract.getEncryptedToken('0x60E610Ebd2EECE95DA52f088Ac67c41A942e625E');
            console.log("encryptedValue:", encryptedValue);
            const tokenAddress = await encryptContract.getTokenAddress(encryptedValue)
            console.log("token Address:", tokenAddress)
        });

        it("get hash test", async () => {
            const { encryptContract, owner } = await loadFixture(deployEncryptContract);
            const hash = await encryptContract.getHash(2, 'aaaa');
            console.log("hash",hash)
            const message = ethers.utils.solidityKeccak256(['address', 'uint256', 'string'], [encryptContract.address, 2, 'aaaa']);
            console.log('same hash', message)
          
            const test = 0x512345673440;
            const signerKey = new ethers.utils.SigningKey(privateKey);
            const signature = signerKey.signDigest(message)
            console.log(await encryptContract.owner())
            const onwerAddr = await encryptContract.mint(2, signature.v, signature.r, signature.s, 'aaaa')
            console.log(publicKey, onwerAddr)

        });

        it("Array assign test in function", async () => {
            const { encryptContract, owner } = await loadFixture(deployEncryptContract);
            await encryptContract.connect(owner).testArray();
            console.log("success")
        })
    })
})