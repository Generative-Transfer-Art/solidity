import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TestNFT is ERC721 {
    uint256 private _nonce;

	constructor() ERC721("Test NFT", "TEST") {
    }

    function mint() external {
        _mint(msg.sender, ++_nonce);
    }

}