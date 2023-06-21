// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.18;

contract Test {
    address public sender;
    event UpdatedSender(address account);
    function setSender() public {
        sender = msg.sender;
        emit UpdatedSender(sender);
    } 
}