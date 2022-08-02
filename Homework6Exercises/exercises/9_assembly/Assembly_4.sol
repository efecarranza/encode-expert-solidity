pragma solidity ^0.8.4;
contract Scope {
    uint public count = 10;
    
    function increment(uint numb) public {        
        assembly {                                 
          let state_count := sload(0x0)
          state_count := add(state_count, numb)
          sstore(0x0, state_count)
        }
    }    
}

                      