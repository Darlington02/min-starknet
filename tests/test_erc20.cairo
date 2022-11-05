%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.uint256 import (Uint256, uint256_sub, uint256_add)

from src.min_erc20.IERC20 import IERC20

// Addresses
const OWNER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const TEST_ACC1 = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const TEST_ACC2 = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;

// Constructor Arguments
const NAME = 33551829125767818279950116212;
const SYMBOL = 4999500;
const DECIMALS = 18;

// @dev setup hook
@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{ context.contract_address = deploy_contract("./src/min_erc20/ERC20.cairo", [ids.NAME, ids.SYMBOL, ids.DECIMALS, 10000, 0, ids.OWNER]).contract_address %}

    return ();
}

// @dev test for name function
@external
func test_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (name) = IERC20.name(contract_address);
    assert NAME = name;

    return ();
}

// @dev test for symbol function
@external
func test_symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (symbol) = IERC20.symbol(contract_address);
    assert SYMBOL = symbol;

    return ();
}

// @dev test for decimals function
@external
func test_decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (decimals) = IERC20.decimals(contract_address);
    assert DECIMALS = decimals;

    return ();
}

// @dev test for totalSupply function
@external
func test_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (total_supply) = IERC20.totalSupply(contract_address);
    assert 10000 = total_supply.low;

    return ();
}

// @dev test for balanceOf function
@external
func test_balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (balance) = IERC20.balanceOf(contract_address, OWNER);
    assert 10000 = balance.low;

    return ();
}

// @dev test for allowance function
@external
func test_allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    let (allowance) = IERC20.allowance(contract_address, OWNER, TEST_ACC1);
    assert 0 = allowance.low;

    return ();
}

// @dev test for transfer function
@external
func test_transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}

    // get old balances of sender and recipient
    let (owner_old_balance) = IERC20.balanceOf(contract_address, OWNER);
    let (test_acc1_old_balance) = IERC20.balanceOf(contract_address, TEST_ACC1);
    
    // start prank as owner to carry out transfer
    %{stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC20.transfer(contract_address, TEST_ACC1, Uint256(1000,0));
    %{ stop_prank_callable() %}

    // get new balances of sender and recipient
    let (owner_new_balance) = IERC20.balanceOf(contract_address, OWNER);
    let (test_acc1_new_balance) = IERC20.balanceOf(contract_address, TEST_ACC1);

    // assert owner lost 1000
    let (owner_diff) = uint256_sub(owner_old_balance, owner_new_balance);
    assert 1000 = owner_diff.low;

    // assert test_acc1 received 1000
    let (test_acc1_diff) = uint256_sub(test_acc1_new_balance, test_acc1_old_balance);
    assert 1000 = test_acc1_diff.low;

    return ();
}

// @dev test for approve function
@external
func test_approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    // approve 1000 tokens as OWNER to TEST_ACC1
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC20.approve(contract_address, TEST_ACC1, Uint256(1000, 0));
    %{ stop_prank_callable() %}
    
    // check allowance of TEST_ACC1 IS 1000
    let (allowance) = IERC20.allowance(contract_address, OWNER, TEST_ACC1);
    assert 1000 = allowance.low;

    return ();
}

// @dev test for transferFrom function
@external
func test_transfer_from{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    
    // approve 1000 tokens as OWNER to TEST_ACC1
    %{ stop_prank_callable = start_prank(ids.OWNER, ids.contract_address) %}
    IERC20.approve(contract_address, TEST_ACC1, Uint256(1000, 0));
    %{ stop_prank_callable() %}

    let (allowance) = IERC20.allowance(contract_address, OWNER, TEST_ACC1);
    
    // transferring from OWNER account as TEST_ACC1
    %{ stop_prank_callable = start_prank(ids.TEST_ACC1, ids.contract_address) %}
    IERC20.transferFrom(contract_address, OWNER, TEST_ACC2, Uint256(300, 0));

    // check TEST_ACC2 balance and TEST_ACC1 allowance
    let (test_acc2_balance) = IERC20.balanceOf(contract_address, TEST_ACC2);
    assert 300 = test_acc2_balance.low;

    let (test_acc1_remaining) = IERC20.allowance(contract_address, OWNER, TEST_ACC1);
    assert 700 = test_acc1_remaining.low;

    // try transferring more than available allowance, operation should revert
    %{ expect_revert("TRANSACTION_FAILED", "ERC20: insufficient allowance") %}
    IERC20.transferFrom(contract_address, OWNER, TEST_ACC2, Uint256(900, 0));

    %{ stop_prank_callable() %}

    return ();
}