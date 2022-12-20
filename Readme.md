# MIN-STARKNET

Min-StarkNet is a side project influenced by Miguel Piedrafita's [Lil-Web3](https://github.com/m1guelpf/lil-web3), aimed at creating minimal, intentionally-limited implementations of different protocols, standards and concepts to help a Cairo beginner learn and become familiar with basic Cairo syntaxes, quickly advancing from beginner to intermediate😉.

## Getting Started
This project uses Protostar as a development framework. To get started with Protostar, follow the guides contained in the [official docs](https://docs.swmansion.com/protostar/docs/tutorials/installation).

Note that Protostar currently has support for just Linux and MacOS, so if you are running a Windows OS, try checking out WSL2.

Having installed Protostar, go ahead to clone the repo, by running the command below on a terminal:

```git clone git@github.com:Darlington02/min-starknet.git```

**PS: Ensure to follow along with the repo, in the order specified below for maximum efficiency, and always read the code comments to effectively understand the underlying codes, AND might be useful to also note that goerli2 was the network mostly used throughout development**

Finally, this repository is targeted at those with basic understanding of how Cairo and StarkNet works. If you do not understand basic Cairo syntax, then take out time to first go through my Journey through Cairo series on [medium](https://medium.com/@darlingtonnnam).

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

The thought process for this application, is we have an ERC20 token deployed on StarkNet, which we intend bridging to Ethereum, to enable users send their tokens between layers. We first have to deploy a clone of our ERC20 token on Ethereum, with zero initial supply (this is done to ensure that the total supply across the different layers when summed up, remains constant). We then deploy our token bridge on both layers, setting the ERC20 token we want to particularly bridge. 

Each time a bridge happens from L2 -> L1, the bridged tokens are locked in the L2 bridge contract, and same amount of the bridged tokens are minted on L1 for the user, and each time a bridge happens from L1 -> L2, the bridged tokens are burnt, and the same amount of bridged tokens is released or transferred from the L2 bridge contract to the user, thereby always keeping total supply constant.

## MIN-UPGRADABILITY
With Regenesis at hand, its become a neccessity to understand how Upgradeable contracts work, in order to successfully migrate existing contracts to Cairo v1.0. In this section we are going to be learning how to create upgradeable contracts by coding up an upgradeable ERC20 token.

In simple terms an Upgradeable contract is one which allows you change the underlying code/logic of your smart contract, without neccessarily altering the entry point (contract address) of your dApp. This is done by separating your contracts into a Proxy and implementation. The Proxy serves as the entry point and also holds the contract storage, whilst the Implementation contains the code/logic of your dApp. For a deeper dive checkout this article by David Baretto [here](https://medium.com/starknet-edu/creating-upgradable-smart-contracts-on-starknet-12b7d9bd60c7)

Thanks to the team at Openzeppelin, we already have a good template to follow. First we'd need to copy the [proxy contract](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/upgrades/presets/Proxy.cairo), into our repo. This proxy contract contains some important functions we'd need to understand:
- The `constructor` which takes in 4 params: `implementation_hash` which is the class hash of our implementation contract, `selector` which is the selector name of our initializer function (1295919550572838631247819983596733806859788957403169325509326258146877103642), `calldata_len` which is the length of our calldata (implementation contract's constructor arguments), and `calldata` which is the implementation contract's constructor arguments. The constructor sets the impelementation hash, and initializes the implementation contract.

- The `__default__` function which is responsible for redirecting any function call whose selector can't be found in the proxy's contract to the implementation.

- The `__l1_default__` function which is responsible for redirecting any function made to an @l1_handler whose selector can't be found in the proxy's contract to the implementation.

Finally we create our implementation contracts adding functions such as `upgrade` for upgrading the implementation hash, `setAdmin` for setting the Proxy admin, `getImplementationHash` for getting the implementation contract class hash and `getAdmin` for getting the current proxy admin.

Note that the implementation contract should never:

1. Be deployed like a regular contract. Instead, the implementation contract should be declared (which creates a DeclaredClass containing its hash and abi).
2. Set its initial state with a traditional constructor (decorated with @constructor). Instead, use an initializer method that invokes the Proxy constructor.

# PLAYGROUND
Looking for an already deployed version of these contracts? check them out on StarkScan (Goerli2).

**PS: If you ever run into an allowance error, you probably needed to call the approve function on the ETH contract beforehand..**

## MIN-ENS
- `ENS` - 0x0340be76bc3bb090a3a339a8ccf6381e7d6620e80e047ddd814268c286dc1e66

## MIN-ERC20
- `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e

## MIN-ERC721
- `ERC721` - 0x02f5222bdb8e68b59736e1490c5ec36ab32f609e4e7058a4042841a51a6cec94

## MIN-NFT-MARKETPLACE
- `ERC721` - 0x02f5222bdb8e68b59736e1490c5ec36ab32f609e4e7058a4042841a51a6cec94
- `NFTMarket` - 0x05b3f40d5cdac77a4e922d8765a5a6ae96e64dc2a4796187d9a25166d0da2235

## MIN-AMM
`AMM` - 0x0219cc693096e2d7df6d6145758fe1b63218725054c61e1fe98cf862cb4c2eb9

## MIN-ICO
- `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
- `ICO` - 0x028afec7907fa30e16aa62e89658d2a416e00f7917a57502d5dc0e43755df103

## MIN-STAKING
- `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
- `STAKING` - 0x06aaa18df6c7a39373d0e153354eda4e1471fab4616837a9ae3295b890abd03a

## MIN-MESSAGING-BRIDGE
- `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
- `L2 BRIDGE ADDRESS` - 0x01c22dddbdbb040268b0a2bb79d62602a57726b2532ee015980f033eb10d8472
- `L1 BRIDGE ADDRESS` - 0xD1A3D5b3Aa75f0884001b2F92d4c7E6050B2eF97

## MIN-UPGRADABILITY
- `Proxy class hash` - 0x601407cf04ab1fbab155f913db64891dc749f4343bc9e535bd012234a46dc61
- `Implementation_v0 class hash` - 0x707e746b94ec595a094ff53dfacb0b6ed8117ba7941844766dd34ab7872107a
- `Implementation_v1 class hash` - 0x1b439f0e941915a2a45bed6d5affed2966010bb5e9b682bc4137178af2a9667
- `Deployed contract` - 0x00701816faf15bf9a97132dbc84d594bf4dd12cea878a8e46254a504ee2187e8

# CONTRIBUTION GUIDELINES
In order to ensure this repository is kept as simple and minimalistic as possible to not get beginners confused, contributions in form of adding new protocols would not be accepted, but if you feel its worth adding to the list, send me a DM on Twitter [Darlington Nnam](https://twitter.com/0xdarlington). In the meantime, you could contribute in form of modifications to the existing projects listed. A good place to get started is checking out the open issues.
Ensure to heed the following in the course of contribution:
1. Keep implementation as simple and minimalistic as possible.
2. Comment codes in details to enable others understand what your codes do. Natspec is the preferred choice.
3. Keep your codes simple and clean.
4. When opening PRs, give a detailed description of what you are trying to fix or add.
Let's build a great learning REPO for frens looking to get started with Cairo. 😉

**If this repo was helpful, do give it a STAR!**