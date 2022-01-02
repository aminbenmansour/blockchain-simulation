# blockchain-simulation

New year new resolutions, never thought of a better beginning.

The whole world is fascinated by Crytocurrency, NFTs, Decentraland and DeFi and waiting for the next IT revolution AKA web 3.0 to happen and migrating to the decentralized world

### goals 

Blockchain as the backbone of all of these technologies is fundamental to understand.

We have been hearing about blockchain for about a while. but understanding Blockchains isn’t easy, or at least wasn’t for me.
I trudged through dense videos, followed porous tutorials, and dealt with the amplified frustration of too few examples.

In this repo we will be learning by doing, It forces me to deal with the subject matter at a code level, which gets it sticking. If you do the same, at the end of this guide you’ll have a functioning blockchain with a solid grasp of how they work.

### before we get started

Remember that a blockchain is an *immutable, sequential chain of records* called **Blocks**. They can contain *transactions, files or any data you like*, really. But the important thing is that they’re chained together using *hashes*.


### representing a blockchain

We’ll create a Blockchain class whose constructor creates an initial empty list (to store our blockchain), and another to store transactions

Our Blockchain class is responsible for managing the chain. It will store transactions and have some helper methods for adding new blocks to the chain.

### what does a Block look like?

Each Block has an index, a timestamp (in Unix time), a list of transactions, a proof (more on that later), and the hash of the previous Block.
Here’s an example of what a single Block looks like:

```
block = {
    'index': 1,
    'timestamp': 1506057125.900785,
    'transactions': [
        {
            'sender': "8527147fe1f5426f9dd545de4b27ee00",
            'recipient': "a77f5cdfa2934df3954a5c7c7da5df1f",
            'amount': 5,
        }
    ],
    'proof': 324984774000,
    'previous_hash': "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
}
```

At this point, the idea of a chain should be apparent—each new block contains within itself, the hash of the previous Block. **This is crucial because it’s what gives blockchains immutability**: If an attacker corrupted an earlier Block in the chain then **all** subsequent blocks will contain incorrect hashes.


### adding a transaction to a block

After *new_transaction()* adds a transaction to the list, it returns the index of the block which the transaction will be added to ***the next one to be mined***. *This will be useful later on, to the user submitting the transaction*.

### creating new blocks

When our Blockchain is instantiated we’ll need to seed it with a `genesis block`, *a block with no predecessors*. We’ll also need to add a **proof to our genesis block** which is **the result of mining** (or `proof of work`).

In addition to creating the genesis block in our constructor, we’ll also flesh out the methods for `new_block()`, `new_transaction()` and `hash()`.

---
At this point, you must be wondering how new blocks are created, forged or mined. :eyes:
---

### Understanding Proof of Work (PoW)

A Proof of Work algorithm (PoW) is how new Blocks are created or mined on the blockchain. The goal of PoW is to discover a number which solves a problem. **The number must be difficult to find but easy to verify**, computationally speaking, by anyone on the network. This is the core idea behind Proof of Work.

We’ll look at a very simple example to help this sink in.

Let’s decide that the hash of some integer x multiplied by another y must end in 0. So, hash(x * y) = ac23dc...0. And for this simplified example, let’s fix x = 5

```
from hashlib import sha256
x = 5  
y = 0  # We don't know what y should be yet...

while sha256(f'{x*y}'.encode()).hexdigest()[-1] != "0":  
    y += 1
    
print(f'The solution is y = {y}')
```

The solution here is y = 21. Since, the produced hash ends in 0

```hash(5 * 21) = 1253e9373e...5e3600155e860```

In Bitcoin, the Proof of Work algorithm is called [Hashcash](https://en.wikipedia.org/wiki/Hashcash). And it’s not too different from our basic example above. It’s the algorithm that miners race to solve in order to create a new block. In general, the difficulty is determined by the number of characters searched for in a string. The miners are then rewarded for their solution by receiving a coin—in a transaction.

The network is able to easily verify their solution.


