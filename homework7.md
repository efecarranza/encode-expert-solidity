# Create a Solidity contract with one function:
# The function should return the amount of ETH that was passed to it, and the function
# body should be written in assembly.

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract Assembly {
    function store() public payable returns (uint amount) {
        uint x = msg.value;
        assembly {
            mstore(0x80, x)
            amount := mload(0x80)
        }
    }
}
```

# Explain what the following code is doing in the Yul ERC20 contract

```
function allowanceStorageOffset(account, spender) -> offset {
    offset := accountToStorageOffset(account)
    mstore(0, offset)
    mstore(0x20, spender)
    offset := keccak256(0, 0x40)
}
```

