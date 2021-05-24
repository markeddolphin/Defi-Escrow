// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract Escrow {

    address public depositor;
    address public beneficiary;
    address public arbiter;

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function approve() external {
        require(msg.sender == arbiter, "Only the arbiter can call this function.");
        payable(beneficiary).transfer(address(this).balance);
    }

}