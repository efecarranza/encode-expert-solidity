pragma solidity ^0.8.4;
contract SubOverflow {

    function subtract(uint x, uint y) public pure returns (uint) {        

        assembly {                        
           let result := add(x, y)
           if lt(result, x) { revert(0,0) }
           mstore(0x80, result)
           return(0x80, 32)
        }
    }    
}

