// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner1;
    address private _owner2;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor(address owner1, address owner2) {
        _setOwner1(owner1);
        _setOwner2(owner2);
    }

    function owner1() public view virtual returns (address) {
        return _owner1;
    }

    function owner2() public view virtual returns (address) {
        return _owner2;
    }

    modifier onlyOwner() {
        require(owner1() == _msgSender() || owner2() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership1(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner1(newOwner);
    }

    function _setOwner1(address newOwner) private {
        address oldOwner = _owner1;
        _owner1 = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _setOwner2(address newOwner) private {
        address oldOwner = _owner2;
        _owner2 = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Blitz is Ownable {
    mapping(string => uint256) public endTimeOfkey;
    uint256 public price;

    event PlanUpdated(string key, uint256 nextEndTime);

    function updatePlan(string memory key) public payable {
        require(msg.value >= price, "InSufficent balance");
        uint256 endTime = endTimeOfkey[key];
        if (endTime == 0 || endTime < block.timestamp) {
            endTime = block.timestamp + 30 * 24 * 3600;
        } else {
            endTime = endTime + 30 * 24 * 3600;
        }
        
        endTimeOfkey[key] = endTime;

        emit PlanUpdated(key, endTime);
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function withDraw1 () public {
        require(owner1());
    }
}