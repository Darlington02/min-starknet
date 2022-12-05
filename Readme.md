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

It implements two external functions, `list_token(token_contract_address, token_id, price)` for listing tokens on the marketplace, and `buy_token(listing_id)` for buying tokens from the marketplace.

Events `listing_created` and `listing_sold` are also emitted each time a Token is listed or sold.

**Note: Remember to call setApprovalForAll(marketplace_contract_address, true) on the contract for the NFT you're listing before calling the `list_token` function**

Test file coming soon..

## MIN-AMM
min-amm is a minimal implementation of an Automated market maker in Cairo. Source codes were gotten and minimally modified from the [Cairo docs](https://www.cairo-lang.org/docs/hello_starknet/amm.html), so you can reference it in case you get confused.

There's also a test file created [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_amm.cairo).

## MIN-ICO
min-ico is a minimal implementation of a presale or ICO in Cairo.
An initial coin offerings (ICOs) is the equivalent of an IPO, a popular way to raise funds for products and services usually related to cryptocurrency. 

The thought process for this application is a user interested in participating in the ICO needs to first register with 0.001ETH by calling the `register` function, then once the ICO duration specified using the `ICO_DURATION` expires, he can now call the external function `claim` to claim his share of ICO tokens.

PS: All users partaking in the ICO pays same amount for registration, and claims equal amount of tokens.

**Note: Remember to call approve(<contract address>, reg_amount) on the StarkNet ETH contract before calling the `register` function**

## MIN-STAKING
min-staking is a minimal implementation of a staking contract in Cairo. 

Staking is a popular process of locking up a certain amount of your crypto holdings to obtain rewards or earn interests.

The thought process for this application requires a user to first deposit a certain amount of the ERC20 token to be staked by calling the `stake(stake_amount, duration_in_secs)` function, and finally claim the tokens + the accrued interest once the duration is over by calling the `claim_rewards(stake_id)` function.

**Note: Remember to call approve(staking_contract_address, stake_amount) on the StarkNet ETH contract before calling the `stake` function**

## MIN-ERC20-MESSAGING-BRIDGE
The ability to create custom messaging bridges on StarkNet for data and asset transfers, is one of the major features that makes StarkNet stand out from other existing rollups. 

In this project, we are going to be creating a simple custom ERC20 Messaging bridge that can help a user transfer an ERC20 token between StarkNet and Ethereum.

## MIN-NFT-MERKLE-DROP
coming soon...


# CONTRIBUTION GUIDELINES
Contributions in form of code modifications or adding new protocols are welcome, but please heed to the following:
1. Ensure to keep implementation as simple and minimalistic as possible.
2. Comment codes in details to enable others understand what your codes do. Natspec is the preferred choice.
3. Keep your codes simple and clean.
4. If you add a new protocol, please also endeavour to update the Readme with a detailed description of what the protocol does.
5. When opening PRs, give a detailed description of what you are trying to fix or add.
6. Let's build a great learning REPO for other developers looking to get started with Cairo. 😉