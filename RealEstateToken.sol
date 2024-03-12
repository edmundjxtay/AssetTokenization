// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
contract RealEstateToken is ERC20 {
    address public admin;
    uint public nextTokenId;
    mapping(uint => RealEstate) public realEstates;
 
    struct RealEstate {
        uint id;
        string name;
        uint price;
        uint totalSupply;
    }
 
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        admin = msg.sender;
    }
 
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
 
    function createRealEstate(string memory _name, uint _price, uint _totalSupply) external onlyAdmin {
        realEstates[nextTokenId] = RealEstate(nextTokenId, _name, _price, _totalSupply);
        _mint(address(this), _totalSupply);
        nextTokenId++;
    }
 
    function buyToken(uint _id, uint _amount) external payable {
        RealEstate storage realEstate = realEstates[_id];
        require(msg.value == realEstate.price * _amount, "Incorrect value sent");
 
        _transfer(address(this), msg.sender, _amount);
    }
 
    function sellToken(uint _id, uint _amount) external {
        RealEstate storage realEstate = realEstates[_id];
        require(balanceOf(msg.sender) >= _amount, "Insufficient token balance");
 
        _transfer(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(realEstate.price * _amount);
    }
}