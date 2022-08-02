# What are the advantages and disadvantages of the 256 bit work length in the EVM?

The advantages of going with a 256-bit word length in the EVM means it can store bigger data than 
other common architecture such as those of 32-bit words or 64-bit words. Those are too restrictive
for what is trying to be done here. Going to 256 makes it a bit (heh) more inefficient but not
where it is prohibitive to perform. 
A lot of cryptographic functionality such as keccack 256 relies on being able to store a hash 
of 256 bits so this is ideal for the EVM.

# What would happen if the implementation of a precompiled contract varied between Ethereum clients?

If the precompiled contract implementations varied, we could end up with different results/gas costs potentially and it'd mean one client is preferred over the other.
It could also mean that, for example, transactions using these precompiled contracts might not work when used by other clients.

# Do we need to validate the beneficiary field in the Ethereum block?

The beneficiary of an ethereum block is not one of the fields validated.
