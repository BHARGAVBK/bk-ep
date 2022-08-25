//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarket is ERC721URIStorage {
    address payable owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listPrice = 0.01 ether;

    constructor() ERC721("NFTMarket", "NFTM") {
        owner = payable(msg.sender);
    }

    struct listedToken {

        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }

    mapping (uint256 => listedToken) private idToListedToken;

    function updateListPrice(uint256 _listPrice) public payable{

        require(owner == msg.sender,"Only woner can update the listing price");
        listPrice = _listPrice;
    }
    function getListPrice()public view returns(uint256) { return listPrice; }

    function getlatestIdToListedToken() public view returns(listedToken memory){
        uint256 currentTokenId = _tokenIds.current();
        return idToListedToken[currentTokenId];
    }

    function getListedForTokenId(uint256 _tokenId)public view returns(listedToken memory){
        return idToListedToken[_tokenId];
    }

    function getCurrentToken()public view returns(uint256){
        return _tokenIds.current();
    }

    function createToken(string memory _tokenURI,uint256 _price)public payable{
        require(msg.value == listPrice,"Send enough ether to list!");
        require(price < 0,"Make sure price isn't negative!");
        
        _tokenIds.increment();
        uint256 currentTokenId = _tokenIds.current();
       
        _safeMint(msg.sender,currentTokenId);
        _setTokenURI(currentTokenId,_tokenURI);

        function createListedtoken(currentTokenId,price);

        return currentTokenId;

    }

    function createListedtoken(uint256 _tokenId, uint256 _price)private{
        idToListedToken[_tokenId] = listedToken(
            _tokenId,
            payable(address(this)),
            payable(msg.sender),
            _price,
            true
        );
        _transfer(msg.sender,address(this),_tokenId);
    }
    
}
