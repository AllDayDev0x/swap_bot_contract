// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.18;


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Proxy is Ownable {

    mapping(address => bool) whitelist;

    modifier onlyWhitelist() {
        require(whitelist[msg.sender], "Caller is not whitelisted");
        _;
    }

    constructor() {
        whitelist[msg.sender] = true;
    }

    function execute(address contractAddy, bytes calldata data) public onlyWhitelist returns (bool) {
        (bool success, ) = contractAddy.call(data);
        return success;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("setSender()");
    }

    function addWhitelist(address account) public onlyOwner {
        whitelist[account] = true;
    } 

    function removeWhitelist(address account) public onlyOwner {
        whitelist[account] = false;
    }
}