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
    
    //helper function
    function updateListPrice(uint256 _listPrice) public payable{

        require(owner == msg.sender,"Only owner can update the listing price");
        listPrice = _listPrice;
    }
    
    //helper function
    function getListPrice()public view returns(uint256) { return listPrice; }
    
    //helper function
    function getlatestIdToListedToken() public view returns(listedToken memory){
        uint256 currentTokenId = _tokenIds.current();
        return idToListedToken[currentTokenId];
    }

    //helper function 
    //       get listedToken for tokenId
    function getListedForTokenId(uint256 _tokenId)public view returns(listedToken memory){
        return idToListedToken[_tokenId];
    }

    //helper function
    function getCurrentToken()public view returns(uint256){
        return _tokenIds.current();
    }

    // main func to create token
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
    
    function getAllNFTs()public view returns(listedToken[] memory){
        uint nftCount = _tokenIds.current();
        listedToken[] memory tokens = new listedToken[](nftCount);
        
        uint currentIndex = 0;

        for (uint i = 0; i < nftCount; i++) 
        {
            uint currentId = i+1;
            listedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        return tokens;
    }

    function getMyNFTs() public view returns(listedToken[] memory){
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint i = 0; i < totalItemCount; i++) {
            if (idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender)
            {
                itemCount + 1;
            }
            
        }
    }
}
