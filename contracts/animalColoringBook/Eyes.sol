// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.6;

library Eyes{
    function sly() internal pure returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="sly">',
                    '<rect x="1" y="1" class="c3">',
                        '<animate attributeName="x" values="1;1;.5;.5;1;1" keyTimes="0;.55;.6;.83;.85;1" dur="13s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="6" y="1" class="c3">',
                        '<animate attributeName="x" values="6;6;5.5;5.5;6;6" keyTimes="0;.55;.6;.83;.85;1" dur="13s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="0" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;1;1;2;1;1;0;0" keyTimes="0;.55;.6;.72;.73;.74;.83;.85;1" dur="13s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;1;1;0;0" keyTimes="0;.55;.6;.83;.85;1" dur="13s" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }

    function aloof(string memory rand1, string memory rand2, string memory rand3) internal view returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="aloof">',
                    '<rect x="0" y="1" class="c3">',
                        '<animate attributeName="x" values="0;0;1;1;0;0" keyTimes="0;.5;.56;.96;.98;1" dur="',
                        rand1,
                        's" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="1;1;0;0;1;1" keyTimes="0;.5;.56;.96;.98;1" dur="',
                        rand2,
                        's" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="1" class="c3">',
                        '<animate attributeName="x" values="5;5;6;6;5;5" keyTimes="0;.5;.56;.96;.98;1" dur="',
                        rand1,
                        's" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="1;1;0;0;1;1" keyTimes="0;.5;.56;.96;.98;1" dur="',
                        rand2,
                        's" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="0" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;0" keyTimes="0;.55;.57;.59;1" dur="',
                        rand3,
                        's" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;0" keyTimes="0;.55;.57;.59;1" dur="',
                        rand3,
                        's" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }

    function dramatic() internal pure returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="dramatic">',
                    '<rect x="0" y="1" class="c3">',
                        '<animate attributeName="x" values="0;0;0;1;1;0;0;" keyTimes="0;.6;.62;.64;.82;.84;1" dur="12s" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="1;1;0;0;0;1;1" keyTimes="0;.6;.62;.64;.82;.84;1" dur="12s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="1" class="c3">',
                        '<animate attributeName="x" values="5;5;5;6;6;5;5" keyTimes="0;.6;.62;.64;.82;.84;1" dur="12s" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="1;1;0;0;0;1;1" keyTimes="0;.6;.62;.64;.82;.84;1" dur="12s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="0" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;0;2;0;0" keyTimes="0;.58;.59;.6;.8;.81;.82;1" dur="12s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;0;2;0;0" keyTimes="0;.58;.59;.6;.8;.81;.82;1" dur="12s" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }

    function flirty() internal pure returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="flirty">',
                    '<rect x="0" y="0" class="c3">',
                        '<animate attributeName="x" values="0;0;1;1;0;0" keyTimes="0;.5;.52;.96;.98;1" dur="20s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c3">',
                        '<animate attributeName="x" values="5;5;6;6;5;5" keyTimes="0;.5;.52;.96;.98;1" dur="20s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="0" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;2;0;0" keyTimes="0;.16;.17;.18;.19;.2;1" dur="10s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;2;0;2;0;0" keyTimes="0;.16;.17;.18;.19;.2;1" dur="10s" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }

    function mischievous() internal pure returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="mischievous">',
                    '<rect x="0" y="1" class="c3 s">',
                        '<animate attributeName="x" values="0;0;1;1;0;0" keyTimes="0;.3;.5;.83;.85;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="1" class="c3 s">',
                        '<animate attributeName="x" values="5;5;6;6;5;5" keyTimes="0;.3;.5;.83;.85;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="0" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;1;1;0;0" keyTimes="0;.2;.25;.63;.65;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c1 l" height="0">',
                        '<animate attributeName="height" values="0;0;1;1;0;0" keyTimes="0;.2;.25;.63;.65;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }

    function shy() internal pure returns (string memory){
        return string(
            abi.encodePacked(
                '<g id="shy">',
                    '<rect x="0" y="0" class="c3">',
                        '<animate attributeName="x" values="0;0;.5;0;0" keyTimes="0;.1;.7;.71;1" dur="8s" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="0;0;.5;0;0" keyTimes="0;.1;.7;.71;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                    '<rect x="5" y="0" class="c3">',
                        '<animate attributeName="x" values="5;5;5.5;5;5" keyTimes="0;.1;.7;.71;1" dur="8s" repeatCount="indefinite"/>',
                        '<animate attributeName="y" values="0;0;.5;0;0" keyTimes="0;.1;.7;.71;1" dur="8s" repeatCount="indefinite"/>',
                    '</rect>',
                '</g>'
            )
        );
    }
}