// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;
import '../libraries/UintStrings.sol';
import 'base64-sol/base64.sol';
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ColoringBookEraser is ERC721, Ownable {
    uint256 private _nonce;
    address public immutable coloringBookContract;

    constructor(address _owner, address _coloringBookContract) ERC721("Animal Coloring Book Eraser", "ERASE") {
        transferOwnership(_owner);
        coloringBookContract = _coloringBookContract;
    }

    function mint(address mintTo) external {
        require(msg.sender == coloringBookContract, "ColoringBookEraser: Coloring Book Contract only");
        _safeMint(mintTo, ++_nonce, "");
    }

    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"',
                                    '#',
                                    UintStrings.decimalString(tokenId, 0, false),
                                    '", "description":"',
                                    'This NFT is a one-time use eraser for an item in the Animal Coloring Book series. Use it to clear all the colors from any Animal you own, destroying the eraser in the process."',
                                    ', "image": "'
                                    'data:image/svg+xml;base64,',
                                    'PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiB2aWV3Qm94PSIwIDAgMTAgMTAiIHhtbDpzcGFjZT0icHJlc2VydmUiIHNoYXBlLXJlbmRlcmluZz0ib3B0aW1pemVTcGVlZCI+Cgo8c3R5bGUgdHlwZT0idGV4dC9jc3MiPgoJcmVjdHt3aWR0aDogMXB4OyBoZWlnaHQ6IDFweDt9CgkuYzF7ZmlsbDojMDBFMEZGO30KCS5jMntmaWxsOiNGRkU1MDA7fQoJLmMze2ZpbGw6I0ZGRDkwMDt9CgkuYzR7ZmlsbDojRkZCRjAwO30KCS5jNXtmaWxsOiNFNUU0RTQ7fQoJLmM2e2ZpbGw6I0NGQ0ZDRjt9CgkuYzd7ZmlsbDojRkVCOUZGO30KCS5jOHtmaWxsOiNGRjdCQ0E7fQo8L3N0eWxlPgoKPHJlY3QgeD0iMCIgeT0iMCIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjEiIHk9IjAiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIyIiB5PSIwIiBjbGFzcz0iYzEiPgoJPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZmlsbCIgdmFsdWVzPSIjMDBFMEZGOyMwMEUwRkY7I0ZGRkZGRjsjMDBFMEZGOyMwMEUwRkY7IiBrZXlUaW1lcz0iMDswLjE1OzAuMjU7MC4zNTsxIiBkdXI9IjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIvPgo8L3JlY3Q+CjxyZWN0IHg9IjMiIHk9IjAiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI0IiB5PSIwIiBjbGFzcz0iYzEiPgoJPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZmlsbCIgdmFsdWVzPSIjMDBFMEZGOyMwMEUwRkY7I0ZGRkZGRjsjMDBFMEZGOyMwMEUwRkY7IiBrZXlUaW1lcz0iMDswLjM7MC40OzAuNTsxIiBkdXI9IjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIvPgo8L3JlY3Q+CjxyZWN0IHg9IjUiIHk9IjAiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI2IiB5PSIwIiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iNyIgeT0iMCIgY2xhc3M9ImMyIi8+CjxyZWN0IHg9IjgiIHk9IjAiIGNsYXNzPSJjMiIvPgo8cmVjdCB4PSI5IiB5PSIwIiBjbGFzcz0iYzMiLz4KCjxyZWN0IHg9IjAiIHk9IjEiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIxIiB5PSIxIiBjbGFzcz0iYzEiPgoJPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZmlsbCIgdmFsdWVzPSIjMDBFMEZGOyMwMEUwRkY7I0ZGRkZGRjsjMDBFMEZGOyMwMEUwRkY7IiBrZXlUaW1lcz0iMDswLjI7MC4zOzAuNDsxIiBkdXI9IjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIvPgo8L3JlY3Q+CjxyZWN0IHg9IjIiIHk9IjEiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIzIiB5PSIxIiBjbGFzcz0iYzEiPgoJPGFuaW1hdGUgYXR0cmlidXRlTmFtZT0iZmlsbCIgdmFsdWVzPSIjMDBFMEZGOyMwMEUwRkY7I0ZGRkZGRjsjMDBFMEZGOyMwMEUwRkY7IiBrZXlUaW1lcz0iMDswLjI7MC4zOzAuNDsxIiBkdXI9IjZzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIvPgo8L3JlY3Q+CjxyZWN0IHg9IjQiIHk9IjEiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI1IiB5PSIxIiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iNiIgeT0iMSIgY2xhc3M9ImMyIi8+CjxyZWN0IHg9IjciIHk9IjEiIGNsYXNzPSJjMiIvPgo8cmVjdCB4PSI4IiB5PSIxIiBjbGFzcz0iYzMiLz4KPHJlY3QgeD0iOSIgeT0iMSIgY2xhc3M9ImMzIi8+Cgo8cmVjdCB4PSIwIiB5PSIyIiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMSIgeT0iMiIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjIiIHk9IjIiIGNsYXNzPSJjMSI+Cgk8YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJmaWxsIiB2YWx1ZXM9IiMwMEUwRkY7IzAwRTBGRjsjRkZGRkZGOyMwMEUwRkY7IzAwRTBGRjsiIGtleVRpbWVzPSIwOzAuMTU7MC4yNTswLjM1OzEiIGR1cj0iNnMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIi8+CjwvcmVjdD4KPHJlY3QgeD0iMyIgeT0iMiIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjQiIHk9IjIiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI1IiB5PSIyIiBjbGFzcz0iYzIiLz4KPHJlY3QgeD0iNiIgeT0iMiIgY2xhc3M9ImMyIi8+CjxyZWN0IHg9IjciIHk9IjIiIGNsYXNzPSJjMyIvPgo8cmVjdCB4PSI4IiB5PSIyIiBjbGFzcz0iYzMiLz4KPHJlY3QgeD0iOSIgeT0iMiIgY2xhc3M9ImM0Ii8+Cgo8cmVjdCB4PSIwIiB5PSIzIiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMSIgeT0iMyIgY2xhc3M9ImMxIj4KCTxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9ImZpbGwiIHZhbHVlcz0iIzAwRTBGRjsjMDBFMEZGOyNGRkZGRkY7IzAwRTBGRjsjMDBFMEZGOyIga2V5VGltZXM9IjA7MC4yNTswLjM1OzAuNDU7MSIgZHVyPSI2cyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiLz4KPC9yZWN0Pgo8cmVjdCB4PSIyIiB5PSIzIiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMyIgeT0iMyIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjQiIHk9IjMiIGNsYXNzPSJjNSIvPgkKPHJlY3QgeD0iNSIgeT0iMyIgY2xhc3M9ImM2Ii8+CjxyZWN0IHg9IjYiIHk9IjMiIGNsYXNzPSJjMyIvPgo8cmVjdCB4PSI3IiB5PSIzIiBjbGFzcz0iYzMiLz4KPHJlY3QgeD0iOCIgeT0iMyIgY2xhc3M9ImM0Ii8+CjxyZWN0IHg9IjkiIHk9IjMiIGNsYXNzPSJjMSIvPgoKPHJlY3QgeD0iMCIgeT0iNCIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjEiIHk9IjQiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIyIiB5PSI0IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMyIgeT0iNCIgY2xhc3M9ImM1Ii8+CjxyZWN0IHg9IjQiIHk9IjQiIGNsYXNzPSJjNiIvPgo8cmVjdCB4PSI1IiB5PSI0IiBjbGFzcz0iYzUiLz4KPHJlY3QgeD0iNiIgeT0iNCIgY2xhc3M9ImM2Ii8+CjxyZWN0IHg9IjciIHk9IjQiIGNsYXNzPSJjNCIvPgo8cmVjdCB4PSI4IiB5PSI0IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iOSIgeT0iNCIgY2xhc3M9ImMxIi8+Cgo8cmVjdCB4PSIwIiB5PSI1IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMSIgeT0iNSIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjIiIHk9IjUiIGNsYXNzPSJjNyIvPgo8cmVjdCB4PSIzIiB5PSI1IiBjbGFzcz0iYzciLz4KPHJlY3QgeD0iNCIgeT0iNSIgY2xhc3M9ImM1Ii8+CjxyZWN0IHg9IjUiIHk9IjUiIGNsYXNzPSJjNiIvPgo8cmVjdCB4PSI2IiB5PSI1IiBjbGFzcz0iYzUiLz4KPHJlY3QgeD0iNyIgeT0iNSIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjgiIHk9IjUiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI5IiB5PSI1IiBjbGFzcz0iYzEiLz4KCjxyZWN0IHg9IjAiIHk9IjYiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIxIiB5PSI2IiBjbGFzcz0iYzciLz4KPHJlY3QgeD0iMiIgeT0iNiIgY2xhc3M9ImM3Ii8+CjxyZWN0IHg9IjMiIHk9IjYiIGNsYXNzPSJjNyIvPgo8cmVjdCB4PSI0IiB5PSI2IiBjbGFzcz0iYzciLz4KPHJlY3QgeD0iNSIgeT0iNiIgY2xhc3M9ImM1Ii8+CjxyZWN0IHg9IjYiIHk9IjYiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI3IiB5PSI2IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iOCIgeT0iNiIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjkiIHk9IjYiIGNsYXNzPSJjMSIvPgoKPHJlY3QgeD0iMCIgeT0iNyIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjEiIHk9IjciIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIyIiB5PSI3IiBjbGFzcz0iYzciLz4KPHJlY3QgeD0iMyIgeT0iNyIgY2xhc3M9ImM3Ii8+CjxyZWN0IHg9IjQiIHk9IjciIGNsYXNzPSJjOCIvPgo8cmVjdCB4PSI1IiB5PSI3IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iNiIgeT0iNyIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjciIHk9IjciIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI4IiB5PSI3IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iOSIgeT0iNyIgY2xhc3M9ImMxIi8+Cgo8cmVjdCB4PSIwIiB5PSI4IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMSIgeT0iOCIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjIiIHk9IjgiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIzIiB5PSI4IiBjbGFzcz0iYzgiLz4KPHJlY3QgeD0iNCIgeT0iOCIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjUiIHk9IjgiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI2IiB5PSI4IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iNyIgeT0iOCIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjgiIHk9IjgiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI5IiB5PSI4IiBjbGFzcz0iYzEiLz4KCjxyZWN0IHg9IjAiIHk9IjkiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSIxIiB5PSI5IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iMiIgeT0iOSIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjMiIHk9IjkiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI0IiB5PSI5IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iNSIgeT0iOSIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjYiIHk9IjkiIGNsYXNzPSJjMSIvPgo8cmVjdCB4PSI3IiB5PSI5IiBjbGFzcz0iYzEiLz4KPHJlY3QgeD0iOCIgeT0iOSIgY2xhc3M9ImMxIi8+CjxyZWN0IHg9IjkiIHk9IjkiIGNsYXNzPSJjMSIvPgoKPC9zdmc+',
                                    '"}'
                                )
                            )
                        )
                )
            );
    }
}
