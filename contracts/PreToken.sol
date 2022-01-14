// contracts/OurToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PreToken is ERC20 {
    constructor() ERC20("PreToken", "PT") {
        _mint(msg.sender, 1000000 * (10 ** 18));
    }
}
// 1000000_000_000_000_000_000_000