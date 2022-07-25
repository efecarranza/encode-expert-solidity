# What information is held for an Ethereum account?

The following four fields are held for an Ethereum account:
1. nonce -> a scalar value equal to the number of txs sent from the address.
2. balance -> a scalar value equal to the number of wei owned by the account.
3. storageRoot -> 256-bit hash of the root node of a Merkle Patricia tree that encodes the storage contents of the account.
4. codeHash -> the hash of the EVM code of the account.

# Where if the full Ethereum state held?

The full Ethereum state is held using Merkle Patricia trees, stored in full nodes.

# What is a replay attack? Which two pieces of information can prevent it?

A replay attack in the context of a blockchain occurs when there's a hardfork, splitting the chain into two. The replay attack in this scenario
works when an attacker submits a transaction that is valid in the old chain and validated again on the upgraded chain version.
Thus, the attacker will double his coin count for example.
In order to protect against replay attacks, the chain ID is not required as part of v, to verify a signature.
The second piece of information used is the fork block number, which makes transfers not available until a certain block is mined.

# What checks are made on transactions for view functions?

The check that is performed is on visibility only, as it does not perform transactions.