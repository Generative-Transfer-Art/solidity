pragma solidity 0.8.6;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ColoringCoordinator {

    // All addresses in `addresses` must have approved this contract to move this token.
    function color(address nftContract, uint256 tokenId, address[] calldata addresses) public {
        address from = address(msg.sender);
        for(uint i=0; i < addresses.length; i++){
            IERC721(nftContract).transferFrom(from, addresses[i], tokenId);
            from = addresses[i];
        }
        IERC721(nftContract).transferFrom(from, msg.sender, tokenId);
    }
}