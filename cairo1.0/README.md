<div align="center">
  <h1>MIN-STARKNET - Cairo 1.0🐺 </h1>
  <h2> ⚡ Blazing ⚡ fast ⚡ compiler for Cairo, written in 🦀 Rust 🦀 </h2>
  <a href="https://github.com/starkware-libs/cairo/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  -
  <a href="https://github.com/starkware-libs/cairo/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  -
  <a href="https://github.com/starkware-libs/cairo/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

[![GitHub Workflow Status](https://github.com/starkware-libs/cairo/actions/workflows/ci.yml/badge.svg)](https://github.com/starkware-libs/cairo/actions/workflows/ci.yml)
[![Project license](https://img.shields.io/github/license/starkware-libs/cairo.svg?style=flat-square)](LICENSE)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/starkware-libs/cairo/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)

</div>


---

## MIN-STARKNET

Min-StarkNet is a side project influenced by Miguel Piedrafita's [Lil-Web3](https://github.com/m1guelpf/lil-web3), aimed at creating minimal, intentionally-limited implementations of different protocols, standards and concepts to help a Cairo beginner learn and become familiar with basic Cairo syntaxes, quickly advancing from beginner to intermediate😉.

## Getting Started

### Prerequisites

- Install [Rust](https://www.rust-lang.org/tools/install)
- Setup Rust:
```bash
rustup override set stable && rustup update && cargo test
```

Having installed Rust, go ahead to clone the repo, by running the command below on a terminal:

`git clone git@github.com:Darlington02/min-starknet.git`

**PS: This project has three branches! The `master` branch serves as a guide, the `develop` branch gives a boilerplate for building on your own, the `Cairo1.0` branch contains all the Cairo1.0 related codes. Simply checkout to the `Cairo1.0` branch to start playing around with the repo**

### Compiling and running Cairo files

Compile Cairo Contracts to Sierra:
```bash
cargo run --bin cairo-compile -- /path/to/input.cairo /path/to/output.sierra --replace-ids
```

Compile Starknet Contracts to Sierra:
```bash
cargo run --bin starknet-compile -- /path/to/input.cairo /path/to/output.sierra --replace-ids
```

Compile Cairo-Sierra to casm (Cairo assembly):
```bash
cargo run --bin sierra-compile -- /path/to/input.sierra /path/to/output.casm
```

Compile Starknet-Sierra to casm (Cairo assembly):
```bash
cargo run --bin starknet-sierra-compile -- /path/to/input.sierra /path/to/output.casm
```

Run Cairo code directly:
```bash
cargo run --bin cairo-run -- -p /path/to/file.cairo
```

See more information [here](./crates/cairo-lang-runner/README.md). You can also find Cairo examples in the [examples](./examples) directory.


## Setting up VSCode for Cairo 1.0 Development

Follow the instructions in [vscode-cairo](./vscode-cairo/README.md).

## Description

### MIN-ENS

Min-ens is a simple implementation of a namespace service in Cairo. It contains a single external function `store_name` and a single view function `get_name`.
A storage variable `names` which is a mapping of **address** to **name**, is also used to store the names assigned to every address, and an event **stored_name** which is emitted each time a name is stored!

A basic test file is also availabe [here](https://github.com/Darlington02/min-starknet/blob/master/tests/test_ens.cairo) to help you learn the basics of writing tests in Cairo with Protostar.

### MIN-ERC20

One of the basic things we learn to do whilst starting out with Smart contract development is learning to build and deploy the popular ERC2O token contract. In this repo, we implement the ERC20 standard from scratch.

The goal for this project is to build and deploy a simple ERC20 token contract.

## PLAYGROUND

Looking for an already deployed version of these contracts? Sadly you can't deploy Cairo 1.0 contracts to Starknet ATM, should be possible with StarkNet Alpha v0.11.0.

## CONTRIBUTION GUIDELINES

In order to ensure this repository is kept as simple and minimalistic as possible to not get beginners confused, contributions in form of adding new protocols would not be accepted, but if you feel its worth adding to the list, send me a DM on Twitter [Darlington Nnam](https://twitter.com/0xdarlington). In the meantime, you could contribute in form of modifications to the existing projects listed. A good place to get started is checking out the open issues.
Ensure to heed the following in the course of contribution:

1. Keep implementation as simple and minimalistic as possible.
2. Comment codes in details to enable others understand what your codes do. Natspec is the preferred choice.
3. Keep your codes simple and clean.
4. When opening PRs, give a detailed description of what you are trying to fix or add.
   Let's build a great learning REPO for frens looking to get started with Cairo. 😉

**If this repo was helpful, do give it a STAR!**