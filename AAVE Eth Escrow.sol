//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;

import "./IERC20.sol";
import "./IWETHGateway.sol";

contract Escrow {
    address arbiter;
    address depositor;
    address beneficiary;
    uint depositAmount;
    
    IWETHGateway gateway = IWETHGateway(0xDcD33426BA191383f1c9B431A342498fdac73488);
    IERC20 aWETH = IERC20(0x030bA81f1c18d280636F32af80b9AAd02Cf0854e);

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
        depositAmount = address(this).balance;

        gateway.depositETH{value: depositAmount}(address(this), 0);
        
    }

    function approve() external {
        require(arbiter == msg.sender, "Only the arbiter can call this function.");
        aWETH.approve(address(gateway), aWETH.balanceOf(address(this)));
        gateway.withdrawETH(type(uint256).max, address(this));
        payable(beneficiary).transfer(depositAmount);
        payable(depositor).transfer(address(this).balance);
    }

    receive() external payable {}
}
