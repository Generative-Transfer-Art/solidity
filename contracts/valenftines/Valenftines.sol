// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {ERC721} from "@rari-capital/solmate/src/tokens/ERC721.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "base64-sol/base64.sol";

import {HexStrings} from "../libraries/HexStrings.sol";


contract Valenftines is ERC721, Ownable {
    struct Valentine {
        uint8 h1;
        uint8 h2;
        uint8 h3;
        uint24 requitedTokenId;
        address to;
        address from;
    }

    uint256 earlymintStartTimestamp; 
    uint256 mintStartTimestamp;
    uint256 mintEndTimestamp;
    bytes32 merkleRoot;
    mapping(uint256 => Valentine) public valentineInfo;
    mapping(uint256 => uint256) public copyOf;
    mapping(uint8 => uint8) public mintCost;

    uint24 private _nonce;

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        
        // Valentine storage v = valentineInfo[id];
        return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"'
                                    '#',
                                    Strings.toString(id),
                                    _tokenName(id),
                                    '", "description":"',
                                    'Valenftines are on-chain art for friends and lovers. They display the address of the sender and recipient along with messages picked by the minter. When the Valenftine is transferred back to the most recent sender, love is REQUITED and the NFT transforms and clones itself so both parties have a copy.',
                                    '", "attributes": [',
                                    tokenAttributes(id),
                                    ']',
                                    ', "image": "'
                                    'data:image/svg+xml;base64,',
                                    Base64.encode(svgImage(id)),
                                    '"}'
                                )
                            )
                        )
                )
            );
    }

    function svgImage(uint256 tokenId) public view returns (bytes memory){
        abi.encodePacked(
            '<?xml version="1.0" encoding="utf-8"?>',
            '<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="400" height="400" class="container"',
                'viewBox="0 0 400 400" style="enable-background:new 0 0 400 400;" xml:space="preserve">',
            '<style type="text/css">',
                '.container{margin: 60px auto; font-size:28px; font-family: monospace, monospace; font-weight: 500; letter-spacing: 2px;}',
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
                '.lightpink{fill:#FFDBDB;}',
            '</style>',
            // '<defs>',
            //     '<g id="heart">',
            //         '<path d="M79.2-43C71.2-78.4,30.8-84.9,5-60.9c-2.5,2.3-6.4,2.1-8.8-0.3c-25-25.9-75.1-15-76.7,28.2C-82.6,22.3-14,75.2,1.5,75.1C17.3,75.1,91.3,10.7,79.2-43z"/>',
            //     '</g>',
            //     '<radialGradient id="rainbow" cx="58%" cy="50%" fr="0%" r="300%" spreadMethod="repeat">',
            //     '<stop offset="0%" style="stop-color:#ffb9b9" />',
            //     '<stop offset="30%" style="stop-color:#fff7ad" />',
            //     '<stop offset="50%" style="stop-color:#97fff3" />',
            //     '<stop offset="80%" style="stop-color:#cfbcff" />',
            //     '<stop offset="100%" style="stop-color:#ffb9b9" />',
            //     '</radialGradient>',
            // '</defs>',

            // '<rect fill="url(#rainbow)" width="400" height="400"/>',

            // '<animate xlink:href="#rainbow"',
            //     'attributeName="fr"',
            //     'dur="20s"',
            //     'values="0%;300%"',
            //     'repeatCount="indefinite"',
            // '/>',

            // '<animate xlink:href="#rainbow"',
            //     'attributeName="r"',
            //     'dur="20s"',
            //     'values="300%;600%"',
            //     'repeatCount="indefinite"',
            // '/>',

            // '<g transform="translate(93,96) rotate(10)">',
            //     '<use xlink:href="#heart" class="whiteheart"/>',
            //     '<text class="pinktext">',
            //         '<tspan x="0" y="-10">0x7A43</tspan>',
            //     '</text>',
            // '</g>',

            // '<g transform="translate(236,209) rotate(-10)">',
            //     '<use xlink:href="#heart" class="whiteheart"/>',
            //     '<text class="pinktext">',
            //         '<tspan x="0" y="-10">0xCC81</tspan>',
            //     '</text>',
            // '</g>',

            // '<g transform="translate(327,62) rotate(-16)">',
            //     '<use xlink:href="#heart" class="pink"/>',
            //     '<text class="pinktext">',
            //         '<tspan x="10" y="-15">2THE</tspan>',
            //         '<tspan x="0" y="20">MOON</tspan>',
            //     '</text>',
            // '</g>',

            // '<g transform="translate(102,325) rotate(7)">',
            //     '<use xlink:href="#heart" class="blue"/>',
            //     '<text class="pinktext">',
            //         '<tspan x="10" y="-15">BULLISH</tspan>',
            //         '<tspan x="0" y="20">4LOVE</tspan>',
            //     '</text>',
            // '</g>',

            // '<g transform="translate(340,344) rotate(-22)">',
            //     '<use xlink:href="#heart" class="yellow"/>',
            //     '<text class="pinktext">',
            //         '<tspan x="10" y="-15">BE</tspan>',
            //         '<tspan x="0" y="20">MINE</tspan>',
            //     '</text>',
            // '</g>',

            // '<g transform="translate(-40,210) rotate(27)">',
            //     '<use xlink:href="#heart" class="orange"/>',
            // '</g>',

            // '<g transform="translate(460,190) rotate(-22)">',
            //     '<use xlink:href="#heart" class="purple"/>',
            // '</g>',

            '</svg>'
        );
    }

    function _tokenName(uint256 tokenId) private view returns(string memory){
        uint256 copy = copyOf[tokenId];
        uint24 requitedId = valentineInfo[tokenId].requitedTokenId;
        return requitedId == 0 ?
                string(
                    abi.encodePacked(
                    ' (',
                    (copy == 0 ? 
                        Strings.toString(copy) 
                        : Strings.toString(requitedId)
                    ), 
                    ')'
                    )
                ) 
                : '';
    }

    function tokenAttributes(uint256 tokenId) public view returns(string memory) {
        return string(
            abi.encodePacked(
                '{',
                '"trait_type": "Requited",', 
                '"value":"',
                valentineInfo[tokenId].requitedTokenId == 0 ? 'false' : 'true',
                '"}',
                ', {',
                '"trait_type": "Coloring",', 
                '"value":"',
                '1',
                '/4',
                '"}'
            )
        );
    }

    constructor(
        uint256 _earlymintStartTimestamp, 
        uint256 _mintStartTimestamp, 
        uint256 _mintEndTimestamp,
        bytes32 _merkleRoot
    ) 
        ERC721("Valenftines", "GTAP3")
    {
        earlymintStartTimestamp = _earlymintStartTimestamp;
        mintStartTimestamp = _mintStartTimestamp;
        mintEndTimestamp = _mintEndTimestamp;
        merkleRoot = _merkleRoot;
    }

    function mint(address to, uint8 h1, uint8 h2, uint8 h3) payable external returns(uint256 id) {
        require(mintCost[h1] + mintCost[h2] + mintCost[h3] <= msg.value, '1');
        require(block.timestamp > mintStartTimestamp, '2');
        require(block.timestamp < mintEndTimestamp, '3');
        
        id = ++_nonce;
        Valentine storage v = valentineInfo[id];
        v.from = msg.sender;
        v.to = to;
        v.h1 = h1;
        v.h2 = h2;
        v.h3 = h3;
        _safeMint(to, id);
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual override {
        _beforeTransfer(from, to, id);
        super.transferFrom(from, to, id);
    } 

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public virtual override {
        _beforeTransfer(from, to, id);
        super.safeTransferFrom(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes memory data
    ) public virtual override {
        _beforeTransfer(from, to, id);
        super.safeTransferFrom(from, to, id, data);
    }

    function _beforeTransfer(
        address from,
        address to,
        uint256 id
    ) private {
        Valentine storage v = valentineInfo[id];
        if (v.requitedTokenId == 0 && copyOf[id] == 0){
            if(to == v.from){
                _mint(from, ++_nonce);
                v.requitedTokenId = _nonce;
                copyOf[_nonce] = id;
            } else {
                v.from = from;
                v.to = to;
            }
        }
    }
}
