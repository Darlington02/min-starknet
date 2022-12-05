# MIN-STARKNET

Min-StarkNet is a side project influenced by Miguel Piedrafita's [Lil-Web3](https://github.com/m1guelpf/lil-web3), aimed at creating minimal, intentionally-limited implementations of different protocols, standards and concepts to help a Cairo beginner learn and become familiar with basic Cairo syntaxes.

## Getting Started
This project uses Protostar as a development framework. To get started with Protostar, follow the guides contained in the [official docs](https://docs.swmansion.com/protostar/docs/tutorials/installation).

Note that Protostar currently has support for just Linux and MacOS, so if you are running a Windows OS, try checking out WSL2.

Having installed Protostar, go ahead to clone the repo, by running the command below on a terminal:
```git clone git@github.com:Darlington02/min-starknet.git```

**PS: Ensure to follow along with the repo, in the order specified below for maximum efficiency, and always read the code comments to effectively understand the underlying codes**

## MIN-ENS
Min-ens is a simple implementation of a namespace service in Cairo. It contains a single external function `store_name` and a single view function `get_name`.
A storage variable `names` which is a mapping of **address** to **name**, is also used to store the names assigned to every address, and an event **stored_name** which is emitted each time a name is stored!

A basic test file is also availabe [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_ens.cairo) to help you learn the basics of writing tests in Cairo with Protostar.

## MIN-ERC20
One of the basic things we learn to do whilst starting out with Smart contract development is learning to build and deploy the popular ERC2O token contract. In this repo, we implement the ERC20 standard using [Openzeppelin's library](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc20/library.cairo).

The goal for this project is to build and deploy a simple ERC20 token contract.

To get better at writing tests, you could try understanding and replicating the ERC20 cairo contract test [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_erc20.cairo).

## MIN-ERC721
min-erc721 implements the ERC721 token standard (non-fungible tokens) in Cairo using [Openzeppelin's library](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc721/library.cairo).

The goal is to build and deploy a simple ERC721 contract on Starknet.

There's also a test file available [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_erc721.cairo)

## MIN-NFT-MARKETPLACE
min-nft-marketplace is a minimal implementation of an NFT Marketplace for buying and selling NFT Tokens.

It implements two external functions, **list_token(token_contract_address, token_id, price)** for listing tokens on the marketplace, and **buy_token(listing_id)** for buying tokens from the marketplace.

Events **listing_created** and **listing_sold** are also emitted each time a Token is listed or sold.

**Note: Remember to call setApprovalForAll(<contract address>, true) on the contract for the NFT you're listing before calling the list function**

Test file coming soon..

## MIN-AMM
min-amm is a minimal implementation of an Automated market maker in Cairo. Source codes were gotten and minimally modified from the [Cairo docs](https://www.cairo-lang.org/docs/hello_starknet/amm.html), so you can reference it in case you get confused.

There's also a test file created [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_amm.cairo).
