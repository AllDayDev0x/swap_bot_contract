
const ethers = require('ethers');

const config = require("./config");
const abi = require('./abi.json');

const contractAddy = config.contractAddy;
const provider = new ethers.providers.JsonRpcProvider(config.rpc);

const contract = new ethers.Contract(contractAddy, abi, provider);
const decodedData = contract.interface.decodeFunctionData(config.txData);
console.log(decodedData)