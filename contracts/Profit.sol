// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Profit {

    address public owner1;
    address public owner2;

    mapping(address => mapping(address => bool)) signersForFirst;
    mapping(address => mapping(address => bool)) signersForSecond;

    uint256 private profitRate1 = 5;
    uint256 private profitRate2 = 5;

    uint256 private balance1;
    uint256 private balance2;

    uint256 withDrawCount;

    constructor (address _owner1, address _owner2) {
        owner1 = _owner1;
        owner2 = _owner2;
    }

    function onlyOwner1() internal view {
        require(msg.sender == owner1, 'not owner1'); 
    }

    function getSignerAddress(uint8 v, bytes32 r, bytes32 s)
    function setSignersForFirst(address[] memory signers, uint8 v, bytes32 r, bytes32 s) public {
        onlyOwner1();

    }

}