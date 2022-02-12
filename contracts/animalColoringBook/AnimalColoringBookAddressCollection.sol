pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import './AnimalColoringBook.sol';
import './AnimalColoringBookDescriptors.sol';
import 'base64-sol/base64.sol';

contract AnimalColoringBookAddressCollection is ERC721, Ownable {
    uint256 private _nonce;
    address immutable private animalColoringBook;
    address immutable private animalColoringBookDescriptors;

    constructor(address _owner, address _animalColoringBook, address _animalColoringBookDescriptors) ERC721("Animal Coloring Book Address Collection Viewer", "ACB-ACV"){
        transferOwnership(_owner);
        animalColoringBook = _animalColoringBook;
        animalColoringBookDescriptors = _animalColoringBookDescriptors;
    }

    function mint(address to) external {
        require(balanceOf(to) == 0, 'AnimalColoringBookAddressCollection: address already minted');
        _safeMint(to, ++_nonce);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(from == address(0), 'AnimalColoringBookAddressCollection: no transfers allowed');
    }

    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        address owner = ownerOf(tokenId);
        return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"Animal Coloring Book Collection of ',
                                    Strings.toHexString(uint256(uint160(owner))),
                                    '", "description":"',
                                    "This NFT is non-transferable and is free to mint, one per address. This NFT's purpose is to display the owner's Animal Coloring Book collection in one image. The image contains up to six Animal Coloring Books which are owned by the address. Image is generated and stored entirely on chain.",
                                    '", "image": "',
                                    'data:image/svg+xml;base64,',
                                    Base64.encode(svg(owner, tokenId)),
                                    '"}'
                                )
                            )
                        )
                )
            );
    }

    function svg(address owner, uint256 tokenId) public view returns(bytes memory){
        return abi.encodePacked(
                '<svg version="1.1" shape-rendering="optimizeSpeed" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 960 630" width="960" height="630" xml:space="preserve">',
                buildAnimals(owner, tokenId),
                '</svg>'
            );
    }

    function buildAnimals(address owner, uint256 tokenId) public view returns(string memory result) {
        uint256 tokenCount = AnimalColoringBook(animalColoringBook).balanceOf(owner);
        uint256 min = tokenCount < 6 ? tokenCount : 6;
        for (uint i; i < min; i++){
                uint256 tokenId = AnimalColoringBook(animalColoringBook).tokenOfOwnerByIndex(owner, i);
                (uint8 animalType, uint8 mood) = AnimalColoringBook(animalColoringBook).animalInfo(tokenId);
                address[] memory history = AnimalColoringBook(animalColoringBook).transferHistory(tokenId);
                result = string(abi.encodePacked(result, 
                '<image href="data:image/svg+xml;base64,',
                Base64.encode(AnimalColoringBookDescriptors(animalColoringBookDescriptors).svgImage(tokenId, animalType, mood, history)),
                '" x="',
                Strings.toString(i * 300 % 900 + (i % 3) * 30),
                '" y="',
                Strings.toString((i / 3 * 300) + (i / 3 * 30)),
                '"/>'
                ));
            }
    }
}