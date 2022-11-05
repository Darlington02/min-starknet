%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.uint256 import (Uint256, uint256_sub, uint256_add)

from src.min_erc721.IERC721 import IERC721

// Addresses
const OWNER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;

// Constructor Arguments
const NAME = 1443913798310970484084;
const SYMBOL = 5129805;

// @dev setup hook
@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{ context.contract_address = deploy_contract("./src/min_erc721/ERC721.cairo", [ids.NAME, ids.SYMBOL, ids.OWNER]).contract_address %}

    return ();
}

// @dev test for name function
@external
func test_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    let (name) = IERC721.name(contract_address);
    assert NAME = name;

    return ();
}

// @dev test for symbol function
@external
func test_symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    let (symbol) = IERC721.symbol(contract_address);
    assert SYMBOL = symbol;

    return ();
}

// @dev test for balanceOf function
@external
func test_balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    let (balance) = IERC721.balanceOf(contract_address, OWNER);
    assert 0 = balance.low;

    // mint as owner and check balance updated
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, OWNER);
    %{ stop_prank_callable() %}

    let (balance) = IERC721.balanceOf(contract_address, OWNER);
    assert 1 = balance.low;

    return ();
}

// @dev test for ownerOf function
@external
func test_ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // mint a new token to TEST_ACC1
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, TEST_ACC1);
    %{ stop_prank_callable() %}

    // check that owner of token is TEST_ACC1
    let token_id_as_uint = Uint256(1, 0);
    let (owner) = IERC721.ownerOf(contract_address, token_id_as_uint);

    assert TEST_ACC1 = owner;
    return ();
}

// @dev test for getApproved function
@external
func test_getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // mint a new token to OWNER
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, OWNER);

    // approve minted token to be spent by TEST_ACC1
    let token_id_as_uint = Uint256(1, 0);
    IERC721.approve(contract_address, TEST_ACC1, token_id_as_uint);

    // check that TEST_ACC1 is the new approved spender
    let (approved) = IERC721.getApproved(contract_address, token_id_as_uint);

    assert TEST_ACC1 = approved;

    %{ stop_prank_callable() %}
    return ();
}

// @dev test isApprovedForAll function
@external
func test_isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // mint 2 new tokens to OWNER
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, OWNER);
    IERC721.mint(contract_address, OWNER);

    // make TEST_ACC2 an authorized operator for all OWNER's tokens
    IERC721.setApprovalForAll(contract_address, TEST_ACC2, 1);

    // check that TEST_ACC2 has been made an authorized operator
    let (isApproved) = IERC721.isApprovedForAll(contract_address, OWNER, TEST_ACC2);

    assert 1 = isApproved;

    %{ stop_prank_callable() %}
    return ();
}

// @dev test transferFrom function
@external
func test_transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // mint a new token to OWNER
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, OWNER);

    // attempt transferring minted token to TEST_ACC1
    let token_id_as_uint = Uint256(1, 0);
    IERC721.transferFrom(contract_address, OWNER, TEST_ACC1, token_id_as_uint);

    // check that owner of token is now TEST_ACC1 
    let (owner) = IERC721.ownerOf(contract_address, token_id_as_uint);

    assert TEST_ACC1 = owner;

    %{ stop_prank_callable() %}
    return ();
}

// @dev test mint function
@external
func test_mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // check that initial balance is 0
    let (balance) = IERC721.balanceOf(contract_address, TEST_ACC2);
    assert 0 = balance.low;

    // mint and check TEST_ACC2 balance updated
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC721.mint(contract_address, TEST_ACC2);
    %{ stop_prank_callable() %}

    let (balance) = IERC721.balanceOf(contract_address, TEST_ACC2);
    assert 1 = balance.low;

    return ();
}