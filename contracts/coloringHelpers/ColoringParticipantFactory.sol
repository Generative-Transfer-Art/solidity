pragma solidity 0.8.6;
import "./ColoringParticipant.sol";

contract ColoringParticipantFactory {
    address immutable public nftContract;
    address immutable public coloringCoordinator;
    address[] private _participants;

    function participants() external view returns (address[] memory){
        return _participants;
    }

    constructor(address _nftContract, address _coloringCoordinator) {
        nftContract = _nftContract;
        coloringCoordinator = _coloringCoordinator;
    }

    function createNewColoringParticipantContract() external {
        address n = address(new ColoringParticipant(nftContract, coloringCoordinator));
        _participants.push(n);
    }
}