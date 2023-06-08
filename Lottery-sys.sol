// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function buyTicket() public payable {
        require(msg.value > 0.01 ether, "Insufficient payment");
        players.push(msg.sender);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function selectWinner() public restricted {
        require(players.length > 0, "No players in the lottery");

        uint index = random() % players.length;
        address payable winner = payable(players[index]);

        uint prizeAmount = address(this).balance;
        winner.transfer(prizeAmount);

        // Reset the lottery for the next round
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }
}
