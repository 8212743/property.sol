// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Place is ERC20, Ownable {

    mapping(string => uint256) public PlacePrices;
    mapping(address => string[]) public PlaceCollection;  

    constructor() ERC20("PlaceToken", "PLACE") Ownable(msg.sender) {
        // Initial place items
        PlacePrices["Beach"] = 700;   // Beach
        PlacePrices["Mountain"] = 1000;  // Mountain
        PlacePrices["City"] = 1200;  // City
        PlacePrices["Forest"] = 500;   // Forest
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function transferPlace(address _to, uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Transfer failed: Insufficient balance.");
        transfer(_to, _amount);
    }

    function showPlaceItems() external pure returns (string memory) {
        return "Places on sale: Beach, Mountain, City, Forest";
    }

    function redeemPlace(string memory _place) public {
        require(PlacePrices[_place] > 0, "Redeem failed: Place is not available.");
        require(balanceOf(msg.sender) >= PlacePrices[_place], "Redeem failed: Insufficient balance.");
        
        _transfer(msg.sender, owner(), PlacePrices[_place]);  
        PlaceCollection[msg.sender].push(_place);  
    }
    
    function burn(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Burn failed: Insufficient balance.");
        _burn(msg.sender, _amount);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function getPlaceCollection(address _user) external view returns (string[] memory) {
        return PlaceCollection[_user];
    }

    function addPlaceItem(string memory _place, uint256 _price) external onlyOwner {
        require(_price > 0, "Add failed: Price must be greater than zero.");
        require(PlacePrices[_place] == 0, "Add failed: Place already exists.");
        PlacePrices[_place] = _price;
    }

    function updatePlaceItem(string memory _place, uint256 _price) external onlyOwner {
        require(_price > 0, "Update failed: Price must be greater than zero.");
        require(PlacePrices[_place] > 0, "Update failed: Place does not exist.");
        PlacePrices[_place] = _price;
    }

    function removePlaceItem(string memory _place) external onlyOwner {
        require(PlacePrices[_place] > 0, "Remove failed: Place does not exist.");
        delete PlacePrices[_place];
    }

    function getPlacePrice(string memory _place) public view returns (uint256) {
        require(PlacePrices[_place] > 0, "Place does not exist.");
        return PlacePrices[_place];
    }
}
