pragma solidity 0.8.6;

interface IAnimalSVG {
    function svg(string memory eyes) external pure returns(string memory);
}
