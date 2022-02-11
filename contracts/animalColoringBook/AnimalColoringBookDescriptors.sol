// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.6;
import '../libraries/UintStrings.sol';
import './AnimalDescriptors.sol';
import 'base64-sol/base64.sol';

interface IAnimalColoringBook{
    function animalInfo(uint256 tokenId) external view returns (uint8, uint8);
    function transferHistory(uint256 tokenId) external view returns (address[] memory);
}

interface IAnimalDescriptors{
    function animalSvg(uint8 animalType, uint8 mood) external view returns (string memory);
    function moodSvg(uint8 mood) external view returns (string memory);
    function animalTypeString(uint8 animalType) external view returns (string memory);
    function moodTypeString(uint8 mood) external view returns (string memory);
    // function randomishIntLessThan(bytes32 salt, uint8 n) external view returns (uint8);
}

contract AnimalColoringBookDescriptors {
    address public animalDescriptors;

    constructor(address _animalDescriptors) {
        animalDescriptors = _animalDescriptors;
    }

    function addressH(address account) public view returns (string memory){
        uint256 h = uint256(keccak256(abi.encodePacked(account))) % 360;
        return UintStrings.decimalString(h, 0, false);
    }

    function tokenURI(uint256 tokenId, IAnimalColoringBook animalColoringBook) external view returns(string memory) {
        (uint8 animalType, uint8 mood) = animalColoringBook.animalInfo(tokenId);
        address[] memory history = animalColoringBook.transferHistory(tokenId);
        return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"',
                                    '#',
                                    UintStrings.decimalString(tokenId, 0, false),
                                    ' - ',
                                    history.length < 4 ? '' : string(abi.encodePacked(IAnimalDescriptors(animalDescriptors).moodTypeString(mood), ' ')),
                                    IAnimalDescriptors(animalDescriptors).animalTypeString(animalType),
                                    '", "description":"',
                                    "The first four transfers of this NFT add a color to part of the image. First, the background. Second, the body. Third, the nose and mouth. And finally, the eyes. The colors are determined by the to address of the transfer. On the fourth transfer, the Animal's mood is revealed, corresponding to the animation of its eyes. The SVG image and animation are generated and stored entirely on-chain.",
                                    '", "attributes": [',
                                    '{',
                                    '"trait_type": "Type",', 
                                    '"value":"',
                                    IAnimalDescriptors(animalDescriptors).animalTypeString(animalType),
                                    '"}',
                                    ', {',
                                    '"trait_type": "Coloring",', 
                                    '"value":"',
                                    UintStrings.decimalString(history.length, 0, false),
                                    '/4',
                                    '"}',
                                    moodTrait(mood),
                                    ']',
                                    ', "image": "'
                                    'data:image/svg+xml;base64,',
                                    Base64.encode(bytes(svgImage(tokenId, animalType, mood, history))),
                                    '"}'
                                )
                            )
                        )
                )
            );
    }

    function moodTrait(uint8  mood) public view returns (string memory) {
        if (mood == 0){
            return '';
        }
        return string(
            abi.encodePacked(
                ', {',
                '"trait_type": "Mood",', 
                '"value":"',
                IAnimalDescriptors(animalDescriptors).moodTypeString(mood),
                '"}'
            )
        );
    }


    function svgImage(uint256 tokenId, uint8 animalType, uint8 mood, address[] memory history) public view returns (bytes memory){
        return abi.encodePacked(
                '<svg version="1.1" shape-rendering="optimizeSpeed" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 10 10" width="300" height="300" xml:space="preserve">',
                styles(tokenId, history),
                IAnimalDescriptors(animalDescriptors).animalSvg(animalType, mood),
                '</svg>'
            );
    }

    function styles(uint256 tokenId, address[] memory history) public view returns (string memory) {
        string memory color1 = history.length > 0 ? string(abi.encodePacked('hsl(', addressH(history[0]),',100%,50%)')) : '#ffffff;';
        string memory color2 = history.length > 1 ? string(abi.encodePacked('hsl(', addressH(history[1]),',100%,50%)')) : '#ffffff;';
        string memory color3 = history.length > 2 ? string(abi.encodePacked('hsl(', addressH(history[2]),',100%,50%)')) : history.length > 1 ? color2 : '#ffffff';
        string memory color4 = history.length > 3 ? string(abi.encodePacked('hsl(', addressH(history[3]),',100%,50%)')) : history.length > 1 ? color2 : '#ffffff';
        string memory color5 = history.length < 4 ? color2 : '#ffffff;';
        return string(
            abi.encodePacked(
                '<style type="text/css">',
                    'rect{width: 1px; height: 1px;}',
                    '.l{width: 2px; height: 1px;}',
	                '.c1{fill:',
                    color2
                    ,'}',
                    '.c2{fill:',
                    color3
                    ,'}'
                    '.c3{fill:',
                    color4
                    ,'}'
                    '.c4{fill:',
                    color1
                    ,'}'
                    '.c5{fill:',
                    color5,
                    '}',
                '</style>'
                )
        );

    }
}