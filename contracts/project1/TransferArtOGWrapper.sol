// SPDX-License-Identifier: BUSL-1.1
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./TransferArt.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TransferArtOGWrapper is ERC721Enumerable, IERC721Receiver, Ownable {
    address immutable public gtap1Contract; 

    constructor(address _owner, address _gtap1Contract) ERC721("Wrapped GTAP1 Originals", "WGTAP1-OG") {
        gtap1Contract = _gtap1Contract;
        transferOwnership(_owner);
    }

    // using safeTransferFrom is simpler, but can use this if Wrapper is approved
    function deposit(address from, address to, uint256 tokenId) public {
        require(TransferArt(gtap1Contract).copyOf(tokenId) == 0, "TransferArtOGWrapper: Only originals");
        TransferArt(gtap1Contract).transferFrom(from, address(this), tokenId);
        _safeMint(to, tokenId, "");
    }

    function withdraw(address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "TransferArtOGWrapper: caller is not owner nor approved");
        TransferArt(gtap1Contract).transferFrom(address(this), to, tokenId);
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public override view returns(string memory) {
        require(_exists(tokenId), "TransferArtOGWrapper: token does not exist");
        return TransferArt(gtap1Contract).tokenURI(tokenId);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes memory
    ) public virtual override returns (bytes4) {
        require(msg.sender == gtap1Contract, "TransferArtOGWrapper: GTAP1 only");
        require(TransferArt(gtap1Contract).copyOf(tokenId) == 0, "TransferArtOGWrapper: Only originals");
        _safeMint(from, tokenId, "");

        return this.onERC721Received.selector;
    }
}