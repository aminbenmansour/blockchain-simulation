# blockchain-simulation

New year new resolutions, never thought of a better beginning.

The whole world is fascinated by Crytocurrency, NFTs, Decentraland and DeFi and waiting for the next IT revolution a.k.a web 3.0 to happen and migrating to the decentralized world

### :rocket: usage
 
1. make sure you have python 3.10 installed in addition to pipenv or run ```pip3 install pipenv```
    + start a virtual environment: ```pipenv shell```
    + install dependencies: ```pipenv install``` 
    + run ```python blockchain.py --port <port>```


2. **Dockerized solution**

    in order to run our blockchain in production each node should have to install the needed dependencies. Dockerizing the application is an optimal solution.
    
    + build the application only once
        + ```docker image build -t blockchain:latest .```
    + run an instance of the application
        + ```docker container run --name <name> --publish <port>:5000 blockchain```
    + stop a container
        + ``` docker container stop <name>```
        
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

### Implementing basic Proof of Work


Let’s implement a similar algorithm for our blockchain. Our rule will be similar to the example above:
*Find a number p that when hashed with the previous block’s solution a hash with 4 leading 0s is produced.*

To adjust the difficulty of the algorithm, we could modify the number of leading zeroes. But 4 is sufficient. You’ll find out that the addition of a single leading zero makes a mammoth difference to the time required to find a solution.

---
Our class is almost complete and we’re ready to begin interacting with it using HTTP requests.
---


### :fire: Our Blockchain as an API

We’re going to use the Python Flask Framework. It’s a micro-framework and it makes it easy to map endpoints to Python functions. This allows us talk to our blockchain over the web using HTTP requests.

We’ll create three methods:
+ `/transactions/new` to create a new transaction to a block
+ `/mine` to tell our server to mine a new block.
+ `/chain` to return the full Blockchain.


#### the transaction endpoint

This is what the request for a transaction will look like. It’s what the user sends to the server:
```
{
 "sender": "my address",
 "recipient": "someone else's address",
 "amount": 5
}
```

### the mining endpoint

Our mining endpoint is where the magic happens, and it’s easy. It has to do three things:
1. Calculate the Proof of Work
2. Reward the miner (us) by adding a transaction granting us 1 coin
3. Forge the new Block by adding it to the chain

Note that the recipient of the mined block is the address of our node. And most of what we’ve done here is just interact with the methods on our Blockchain class. At this point, we’re done, and can start interacting with our blockchain.

### :v: interacting with our blockchain

The following pictures will show the result of our interactions with the three endpoints we created.

![Screenshot_20220104_191532](https://user-images.githubusercontent.com/50111205/148106815-691b4e4c-3c64-4586-88a7-ebc23b426aa9.png)

we executed the ```/mine``` endpoint once to produce a new block.

![Screenshot_20220104_191807](https://user-images.githubusercontent.com/50111205/148107002-84c4163b-ac37-4817-9249-2be92f435762.png)

a new transaction were made to the last block.

![Screenshot_20220104_192042](https://user-images.githubusercontent.com/50111205/148107113-fa69b7de-cdf6-4037-ad6e-730680e61bd2.png)
we visualized all blocks (ledgers) with their transactions in the the blockchain.


### consensus

This is very cool. We’ve got a basic Blockchain that accepts transactions and allows us to mine new Blocks. But the whole point of Blockchains is that they should be *decentralized*. And if they’re decentralized, **how on earth do we ensure that they all reflect the same chain?** This is called the problem of Consensus, and we’ll have to implement a Consensus Algorithm if we want more than one node in our network.

#### :office: registering new nodes

1. ```/nodes/register``` to accept a list of new nodes in the form of URLs.
2. ```/nodes/resolve``` to implement our Consensus Algorithm, which resolves any conflicts—to ensure a node has the correct chain.

We’ll need to modify our Blockchain’s constructor and provide a method for registering nodes:
Note that we’ve used a ```set()``` to hold the list of nodes. This is a cheap way of ensuring that the addition of new nodes is idempotent, meaning that no matter how many times we add a specific node, it appears exactly once.

### implementing the consensus algorithm

As mentioned, **a conflict is when one node has a different chain to another node**. To resolve this, we’ll make the rule that *the longest valid chain is authoritative*. In other words, the longest chain on the network is the de-facto one. Using this algorithm, we reach Consensus amongst the nodes in our network.

The first method ```valid_chain()``` is responsible for checking if a chain is valid by looping through each block and verifying both the hash and the proof.

```resolve_conflicts()``` is a method which loops through all our neighbouring nodes, downloads their chains and verifies them using the above method. If a valid chain is found, whose length is greater than ours, we replace ours.

## Contributing

All contributions are welcome and highly appreciated.
For the next step we tend to extend our blockchain to have a **Transaction Validation Mechanism** as well as discuss some ways in which we can productionize our blockchain.

