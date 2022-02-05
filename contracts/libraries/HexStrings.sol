// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

library HexStrings {
    bytes16 internal constant ALPHABET = '0123456789abcdef';

    // @notice returns value as a hex string of desiredPartialStringLength length,
    // adding '0x' to the start
    // Designed to be used for shortening addresses for display purposes.
    // @param value The value to return as a hex string
    // @param desiredPartialStringLength How many hex characters of `value` to return in the string
    // @param valueLengthAsHexString The length of `value` as a hex string
    function partialHexString(
        uint160 value,
        uint8 desiredPartialStringLength,
        uint8 valueLengthAsHexString
    ) 
        internal pure returns (string memory) 
    {
        bytes memory buffer = new bytes(desiredPartialStringLength + 2);
        buffer[0] = '0';
        buffer[1] = 'x';
        uint8 offset = desiredPartialStringLength + 1;
        // remove values not in partial length, four bytes for every hex character
        value >>= 4 * (valueLengthAsHexString - desiredPartialStringLength);
        for (uint8 i = offset; i > 1; --i) {
            buffer[i] = ALPHABET[value & 0xf];
            value >>= 4;
        }
        require(value == 0, 'HexStrings: hex length insufficient');

        return string(buffer);
    }
}