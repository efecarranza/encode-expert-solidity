# How can the use of tx.origin in a contract be exploited?

If a contract is using my contract to call my contract's method, tx.origin will show up as coming from my contract, 
when in reality, the msg.sender is another one. tx.origin cannot be used for authorization.

# What do you understand by event spoofing?

Event spoofing is when an event is emitted that might not have originated from the contract we think, since the events
can have the same signature. It might entice us to take certain actions because of this false information we are dealing with.

# What problems can you find with this contract designed to produce a random number?


```
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract Example1{

    uint256 private rand1 =  block.timestamp;

    function random(uint Max) view public returns (uint256 result){

        uint256 rand2 = Max / rand1;
        return rand2 % Max ;
    }
}
```

Since `block.timestamp` is being used for the division, a miner can manipulate block.timestamp or even wait for a timestamp that's going to be beneficial
to them. This is not going to generate a truly random number and it can be gamed. Use fixed solidity version.

# What problems are there in this contract?

```
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Course {
    // In this contract the students add themselves via the joinCourse function.
    // At a later time the teacher will via a front end call the welcomeStudents function
    // to send a message to the students and get the number of students starting the course.
    address[] students;
    address teacher = 0x94603d2C456087b6476920Ef45aD1841DF940475;

    event welcome(string,address);
    uint startingNumber = 0;

    function joinCourse()public{
        students.push(msg.sender);
    }

    function welcomeStudents() public{
        require(msg.sender==teacher,"Only the teacher can call this function");
        for(uint x; x < students.length; x++) {
        emit welcome("Welcome to the course",students[x]);
        startingNumber++;
        }
    }
}
```

The structure used for students is an array, meaning, students could sign up mutilple times with the same address. This is a waste of time and there's no validation on it. A mapping would have been a better structure. They could also make this array really big and then the loop will run out of gas.

