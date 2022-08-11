# Why are negative numbers more expensive to store than positive numbers?

They use two complements system to store ints vs. uints, they are represented differently than uints
so that's more expensive to store.

# Test the following statements in Remix, which is cheaper and why?
# Assume that the demoninator can never be zero.

`result = numerator / demoninator;`

Uses `22278` gas.

Uses following OPCODES:

PUSH1 00
DUP2
DUP4
PUSH2 006e
SWAP2
SWAP1

```
assembly {
result := div(numerator, demoninator)
}
```

Uses `22105` gas.

Uses following OPCODES:

PUSH1 00
DUP2
DUP4
DIV
SWAP1
POP

Assembly option uses less gas as it's doing one less swap.
