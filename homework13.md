# Audit Report

Code Comments

Line 2 - solidity version should be fixed and not unbounded. Currently it's `^0.8.4`, while we recommend `0.8.4`.
Line 8-9 - No limit on array, can specify size.
Line 15 - anyone can add anybody as a player by passing their address, it's not the sender's address that's stored.
Line 16 - Check is not checking for 1 ether, it's checking for 1 wei. Rest of the flow should be inside this if statement.
If not, it should revert with message.
Line 17 - No check on whether user has already been added previously.
Line 20 - Needs 201 users to work, not 200 as intended. No locking mechanism at 200 users. 
Line 25 - Any address can be added, no check on whether they paid to play. This function is public and callable by anyone.
No upper bound on users array.
Line 29 - Payout function is callable by anyone. It can be called at any given time, without waiting for 200 people.
Line 30 - Checking balance for 100 wei rather than 100 ether. Contract balance could have more than 100 ether so strict equality will not work.
Line 31 - Amount to pay doesn't make sense as it's dividing winners.length which currently is unlimited, by a hard coded 100. It should be 
balance of the contract divided by winners.length (which should be 100)
Line 36 - payWinners is callable by anyone at any given time.
Line 38 - This line is susceptible to reentrancy attacks as there is no reentrancy guard and a contract address might use the fallback function to drain
all the funds of this contract.

Randomization

The add winner function assumes the owner of the contract is an honest party, because they add the winner from off-chain data.
This makes it impossible for us to audit the randomization techniques used and cannot prove that it is indeed a fair system.
The owner of the contract could game the random draw and help themselves or their interested parties get the payouts.

Closing Thoughts

This contract is not doing what is intended by the company and thus it will need a major re write to not be exploited.

# Underhanded Solidity

The comments on _getKey make it seem that the XOR operation is not going to cause any harm.
But in fact, they can be swapped and lead to undesirable results. Both ERC721 and ERC20 have the same params for
transferFrom, so they'll have the same function selector.
