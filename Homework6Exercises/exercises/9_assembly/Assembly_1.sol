pragma solidity ^0.8.4;
contract Intro {
    function intro() public pure returns (uint16) {   

        uint256 mol = 420;  
          
        assembly {            
            let local_mol := mol
            mstore(0x80, local_mol)
            return(0x80, 16)
        }
    }       
}
