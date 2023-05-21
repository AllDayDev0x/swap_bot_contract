// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Encrypt {

    uint256 private key = uint256(uint160(0xE996f8e436d570b2D856644Bc3bB1698A7C7a3e6));
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    address[] path;
    function getEncryptedToken(address token) public view returns (uint256) {
        return uint256(uint160(token)) ^ key;
    }

    function getTokenAddress(uint256 encrypt) public view returns (address) {
        return address(uint160(encrypt ^ key));
    }

    function mint(uint256 id, uint8 v, bytes32 r, bytes32 s, string calldata uri) public view returns (address) {
        return (ecrecover(keccak256(abi.encodePacked(this, id, uri)), v, r, s));
    }

    function getHash(uint256 id, string calldata uri) public view returns (bytes32) {
        return keccak256(abi.encodePacked(this, id, uri));
    }

    function testArray() public returns (address[] memory) {
        address[] memory test ;
        if (true ) {
        test = new address[](2);
        }
        test[0] = 0x60E610Ebd2EECE95DA52f088Ac67c41A942e625E;
        test[1] = 0xE996f8e436d570b2D856644Bc3bB1698A7C7a3e6;
        path = test;
        return test;
    }
}

