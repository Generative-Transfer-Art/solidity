// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import './Eyes.sol';
import '../libraries/UintStrings.sol';
import './interfaces/IAnimalSVG.sol';

contract AnimalDescriptors {
    IAnimalSVG public immutable creator;
    IAnimalSVG public immutable unicorn;
    IAnimalSVG public immutable skull;
    IAnimalSVG public immutable cat;
    IAnimalSVG public immutable mouse;
    IAnimalSVG public immutable bunny;

    constructor(IAnimalSVG _creator, IAnimalSVG _unicorn, IAnimalSVG _skull, IAnimalSVG _cat, IAnimalSVG _mouse, IAnimalSVG _bunny){
        creator = _creator;
        unicorn = _unicorn;
        skull = _skull;
        cat = _cat;
        mouse = _mouse;
        bunny = _bunny;
    }

    function animalSvg(uint8 animalType, uint8 mood) external view returns (string memory){
        string memory moodSVG = moodSvg(mood);
        return (animalType == 1 ? cat.svg(moodSVG) :
                    (animalType == 2 ? bunny.svg(moodSVG) :
                        (animalType == 3 ? mouse.svg(moodSVG) :
                            (animalType == 4 ? skull.svg(moodSVG) : 
                                (animalType == 5 ? unicorn.svg(moodSVG) : creator.svg(moodSVG))))));
    }

    function moodSvg(uint8 mood) public view returns (string memory){
        if(mood == 1){
            string memory rand1 = UintStrings.decimalString(_randomishIntLessThan('rand1', 4) + 10, 0, false);
            string memory rand2 = UintStrings.decimalString(_randomishIntLessThan('rand2', 5) + 14, 0, false);
            string memory rand3 = UintStrings.decimalString(_randomishIntLessThan('rand3', 3) + 5, 0, false);
            return Eyes.aloof(rand1, rand2, rand3);
        } else {
            return (mood == 2 ? Eyes.sly() : 
                        (mood == 3 ? Eyes.dramatic() : 
                            (mood == 4 ? Eyes.mischievous() : 
                                (mood == 5 ? Eyes.flirty() : Eyes.shy()))));
        }
    }

    function _randomishIntLessThan(bytes32 salt, uint8 n) private view returns (uint8) {
        if (n == 0)
            return 0;
        return uint8(keccak256(abi.encodePacked(block.timestamp, msg.sender, salt))[0]) % n;
    }

    function animalTypeString(uint8 animalType) public view returns (string memory){
        return (animalType == 1 ? "Cat" : 
                (animalType == 2 ? "Bunny" : 
                    (animalType == 3 ? "Mouse" : 
                        (animalType == 4 ? "Skull" : 
                            (animalType == 5 ? "Unicorn" : "Creator")))));
    }

    function moodTypeString(uint8 mood) public view returns (string memory){
        return (mood == 1 ? "Aloof" : 
                (mood == 2 ? "Sly" : 
                    (mood == 3 ? "Dramatic" : 
                        (mood == 4 ? "Mischievous" : 
                            (mood == 5 ? "Flirty" : "Shy")))));
    }
}