# When we do the CODECOPY operation, what are we overwriting?

We are overwriting the entire memory with the bytecode from the contract, including the init code.

# Could the answer to Q1 allow an optimization?

Setting the memory pointer could be discarded.

# Can you trigger a revert in the init code in Remix?

Yes, a condition that might revert, will be added to the bytecode and revert on init. You can send wei to the contract and it'll revert.

# Can you think of a situation where the opcode EXTCODECOPY is used?

You could get the bytecode of a different contract you're interacting with, and validate that what you're interacting with
in the blockchain is the same thing as a previously hashed contract.
