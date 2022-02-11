// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "base64-sol/base64.sol";

import {HexStrings} from "./HexStrings.sol";

import {Valenftines, Valentine} from '../valenftines//Valenftines.sol';

library ValenftinesDescriptors {
    function tokenURI(uint256 id, address valenftines) public view returns (string memory) {
        Valentine memory v = Valenftines(valenftines).valentineInfo(id);
        uint256 copy = Valenftines(valenftines).matchOf(id);
        return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"'
                                    '#',
                                    Strings.toString(id),
                                    _tokenName(id, v.requitedTokenId, valenftines),
                                    '", "description":"',
                                    'Valenftines are on-chain art for friends and lovers. They display the address of the sender and recipient along with messages picked by the minter. When the Valenftine is transferred back to the most recent sender, love is REQUITED and the NFT transforms and clones itself so both parties have a copy.',
                                    '", "attributes": [',
                                    tokenAttributes(id, v.requitedTokenId, v.to, v.from),
                                    ']',
                                    ', "image": "'
                                    'data:image/svg+xml;base64,',
                                    Base64.encode(copy > 0 ? svgImage(true, copy, Valenftines(valenftines).valentineInfo(copy)) : svgImage(false, id, v)),
                                    '"}'
                                )
                            )
                        )
                )
            );
    }

    function _tokenName(uint256 tokenId, uint24 requitedTokenId, address valenftines) private view returns(string memory){
        uint256 copy = Valenftines(valenftines).matchOf(tokenId);
        return requitedTokenId == 0 && copy == 0 ?
                '' : 
                string(
                    abi.encodePacked(
                        ' (match of #',
                        copy == 0 ? 
                            Strings.toString(requitedTokenId)
                            : Strings.toString(copy) 
                        , 
                        ')'
                    )
                );
    }

    function tokenAttributes(uint256 tokenId, uint24 requitedTokenId, address to, address from) public view returns(string memory) {
        return string(
            abi.encodePacked(
                '{',
                '"trait_type": "Love",', 
                '"value":"',
                requitedTokenId == 0 ? 'UNREQUITED' : 'REQUITED',
                '"}'
            )
        );
    }

    /// TOKEN ART 

    function svgImage(
        bool isCopy,
        uint256 tokenId, 
        Valentine memory v
    ) 
        public view returns (bytes memory)
    {
        return abi.encodePacked(
            '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="400" height="400" class="container" ',
	            'viewBox="0 0 400 400" style="enable-background:new 0 0 400 400;" xml:space="preserve">',
            styles(tokenId),
            '<defs>',
                '<g id="heart">',
                    '<path d="M79.2-43C71.2-78.4,30.8-84.9,5-60.9c-2.5,2.3-6.4,2.1-8.8-0.3c-25-25.9-75.1-15-76.7,28.2C-82.6,22.3-14,75.2,1.5,75.1C17.3,75.1,91.3,10.7,79.2-43z"/>',
                '</g>',
                '<radialGradient id="rainbow" cx="58%" cy="49%" fr="0%" r="70%" spreadMethod="repeat">',
                '<stop offset="0%" style="stop-color:#ffb9b9" />',
                '<stop offset="30%" style="stop-color:#',
                isCopy ? 'cfbcff' : 'fff7ad',
                '" />',
                '<stop offset="50%" style="stop-color:#97fff3" />',
                '<stop offset="80%" style="stop-color:#',
                isCopy ? 'fff7ad' : 'cfbcff',
                '" />',
                '<stop offset="100%" style="stop-color:#ffb9b9" />',
                '</radialGradient>',
            '</defs>',

            '<rect ',
            v.requitedTokenId != 0 ? 'fill="url(#rainbow)"' : 'class="background"',
            ' width="400" height="400"/>',

            '<animate xlink:href="#rainbow" ',
                'attributeName="fr" ',
                'dur="16s" ',
                'values="0%;25%;0%" ',
                'repeatCount="indefinite"',
            '/>',

            '<animate xlink:href="#rainbow" ',
                'attributeName="r" ',
                'dur="16s" ',
                'values="70%;180%;70%" ',
                'repeatCount="indefinite"',
            '/>',
           
            heartsSVGs(tokenId, v),
            '</svg>'
        );
    }

    function styles(uint256 tokenId) private pure returns(bytes memory) {
        return abi.encodePacked(
            '<style type="text/css">',
                '.container{font-size:28px; font-family: monospace, monospace; font-weight: 500; letter-spacing: 2px;}',
                '.whitetext{fill:#ffffff; text-anchor:middle;}',
                '.blacktext{fill:#000000; text-anchor:middle;}',
                '.pinktext{fill:#FA0F95; text-anchor:middle;}',
                '.whiteheart{fill:#ffffff;}',
                '.whiteheartoutline{fill:#ffffff; stroke: #000000; stroke-width: 6px;}',
                '.black{fill:#000000;}',
                '.pink{fill:#FFC9DF;}',
                '.blue{fill:#A2E2FF;}',
                '.orange{fill:#FFCC99;}',
                '.green{fill:#A4FFCA;}',
                '.purple{fill:#DAB5FF;}',
                '.yellow{fill:#FFF6AE;}',
                '.background{fill:#FFDBDB;}',
            '</style>'
        );
    }

    function heartsSVGs(
        uint256 tokenId,
        Valentine memory v
    ) 
        public view returns (bytes memory)
    {
        bool requited = v.requitedTokenId != 0;
        return abi.encodePacked(
            addrHeart(true, tokenId, requited, v.from),

            addrHeart(false, tokenId, requited, v.to),

            textHeart(1, v.h1, tokenId, requited, v.to, v.from),
            textHeart(2, v.h2, tokenId, requited, v.from, v.to),
            textHeart(3, v.h3, tokenId, requited, address(this), v.from),

            emptyHeart(true, tokenId, requited, v.to),
            emptyHeart(false, tokenId, requited, v.from)
        );
    }

    function addrHeart(bool first, uint256 tokenId, bool requited, address account) private pure returns (bytes memory) {
        string memory xy = first ? '93,96' : '236,209';
        return abi.encodePacked(
            '<g transform="translate(',
            xy,
            ') rotate(',
            rotation(tokenId + (first ? 100 : 101)),
            ')">',
                '<use xlink:href="#heart" class="whiteheart',
                requited ? '' : 'outline',
                '"/>',
                '<text class="',
                requited ? 'pinktext' : 'blacktext',
                '">',
                    '<tspan x="0" y="-10">',
                    HexStrings.partialHexString(uint160(account), 4, 40),
                    '</tspan>',
                '</text>',
            '</g>'
        );
    }

    function textHeart(uint256 index, uint8 heartType, uint256 tokenId, bool requited, address addr1, address addr2) private pure returns (bytes memory) {
        string memory xy = (index < 2 ? '327,62' :
                                index < 3 ? '102,325' : '336,348');
        return abi.encodePacked(
            '<g transform="translate(',
            xy,
            ') rotate(',
            rotation(tokenId + 101 + index),
            ')">',
                '<use xlink:href="#heart" class="',
                requited ? heartColorClass(addr1, addr2) : 'black',
                '"/>',
                '<text class="',
                requited ? 'pinktext' : 'whitetext',
                '">',
                    heartMessageTspans(heartType),
                '</text>',
            '</g>'
        );
    }

    function heartMessageTspans(uint8 heartType) private pure returns(bytes memory){
        return (heartType < 2 ? bullishForYou() :
                (heartType < 3 ? beMine() : 
                (heartType < 4 ? toTheMoon() : 
                (heartType < 5 ? coolCat() : 
                (heartType < 6 ? cutiePie() :
                (heartType < 7 ? zeroXZeroX() : 
                (heartType < 8 ? bestFren() : 
                (heartType < 9 ? bigFan() : 
                (heartType < 10 ? gm() : 
                (heartType < 11 ? coinBae() : 
                (heartType < 12 ? sayIDAO() :
                (heartType < 13 ? wagmi() : 
                (heartType < 14 ? myDegen() : 
                (heartType < 15 ? payMyTaxes() :
                (heartType < 16 ? upOnly() : 
                (heartType < 17 ? lilMfer() : 
                (heartType < 18 ? onboardMe() : 
                (heartType < 19 ? letsMerge() : 
                (heartType < 20 ? hodlMe() : 
                (heartType < 21 ? looksRare() :
                (heartType < 22 ? wenRing() : 
                (heartType < 23 ? idMintYou() : simpForYou()))))))))))))))))))))));
    }

    function emptyHeart(bool first, uint256 tokenId, bool requited, address account) private view returns (bytes memory) {
        string memory xy = first ? '-40,210' : '460,190';
        return abi.encodePacked(
            '<g transform="translate(',
            xy,
            ') rotate(',
            rotation(tokenId + (first ? 104 : 105)),
            ')">',
                '<use xlink:href="#heart" class="',
                requited ? heartColorClass(account, address(this)) : 'black',
                '"/>',
            '</g>'
        );
    }

    function rotation(uint256 n) private pure returns (string memory) {
        uint256 r = n % 30;
        bool isPos = (n % 2) > 0 ? true : false;
        return string(
            abi.encodePacked(
                isPos ? '' : '-',
                Strings.toString(r)
            )
        );
    }

    function heartColorClass(address addr1, address addr2) private pure returns(string memory){
        uint256 i = numberFromAddresses(addr1, addr2, 100) % 6;
        return (i < 1 ? 'pink' : 
            (i < 2 ? 'blue' : 
                (i < 3 ? 'orange' : 
                    (i < 4 ? 'green' : 
                        (i < 5 ? 'purple' : 'yellow')))));

    }

    // gives a number from address where 
    // numberFromAddresses(addr1, addr2, mod) != numberFromAddresses(addr2, addr1, mod)
    function numberFromAddresses(address addr1, address addr2, uint256 mod) private pure returns(uint256) {
        return ((uint160(addr1) % 201) + (uint160(addr2) % 100)) % mod;
    } 

    function gm() private pure returns(bytes memory){
        return oneLineText("GM");
    }

    function zeroXZeroX() private pure returns(bytes memory){
        return oneLineText("0x0x");
    }

    function wagmi() private pure returns(bytes memory){
        return oneLineText("WAGMI");
    }
    
    function bullishForYou() private pure returns(bytes memory){
        return twoLineText("BULLISH", "4YOU");
    }

    function beMine() private pure returns(bytes memory){
        return twoLineText("BE", "MINE");
    }

    function toTheMoon() private pure returns(bytes memory){
        return twoLineText("2THE", "MOON");
    }

    function coolCat() private pure returns(bytes memory){
        return twoLineText("COOL", "CAT");
    }

    function cutiePie() private pure returns(bytes memory){
        return twoLineText("CUTIE", "PIE");
    }

    function bestFren() private pure returns(bytes memory){
        return twoLineText("BEST", "FREN");
    }

    function bigFan() private pure returns(bytes memory){
        return twoLineText("BIG", "FAN");
    }
    
    function coinBae() private pure returns(bytes memory){
        return twoLineText("COIN", "BAE");
    }

    function sayIDAO() private pure returns(bytes memory){
        return twoLineText("SAY I", "DAO");
    }

    function myDegen() private pure returns(bytes memory){
        return twoLineText("MY", "DEGEN");
    }

    function payMyTaxes() private pure returns(bytes memory){
        return twoLineText("PAY MY", "TAXES");
    }

    function upOnly() private pure returns(bytes memory){
        return twoLineText("UP", "ONLY");
    }

    function lilMfer() private pure returns(bytes memory){
        return twoLineText("LIL", "MFER");
    }

    function onboardMe() private pure returns(bytes memory){
        return twoLineText("ONBOARD", "ME");
    }

    function letsMerge() private pure returns(bytes memory){
        return twoLineText("LETS", "MERGE");
    }

    function hodlMe() private pure returns(bytes memory){
        return twoLineText("HODL", "ME");
    }

    function looksRare() private pure returns(bytes memory){
        return twoLineText("LOOKS", "RARE");
    }

    function wenRing() private pure returns(bytes memory){
        return twoLineText("WEN", "RING");
    }

    function simpForYou() private pure returns(bytes memory){
        return twoLineText("SIMP", "4U");
    }

    function idMintYou() private pure returns(bytes memory){
        return threeLineText('ID', 'MINT', 'YOU');
    }

    function oneLineText(string memory text) private pure returns(bytes memory){
        return abi.encodePacked(
            '<tspan x="0" y="-10">',
            text,
            '</tspan>'
        );
    }

    function twoLineText(string memory line1, string memory line2) private pure returns(bytes memory){
        return abi.encodePacked(
            '<tspan x="0" y="-15">',
            line1,
            '</tspan>',
            '<tspan x="0" y="20">',
            line2,
            '</tspan>'
        );
    }

    function threeLineText(string memory line1, string memory line2, string memory line3) private pure returns(bytes memory){
        return abi.encodePacked(
            '<tspan x="0" y="-25">',
            line1,
            '</tspan>',
            '<tspan x="0" y="10">',
            line2,
            '</tspan>',
            '<tspan x="0" y="45">',
            line3,
            '</tspan>'
        );
    }
}