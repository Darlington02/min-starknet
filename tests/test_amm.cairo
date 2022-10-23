%lang starknet

from src.min_amm.amm import get_account_token_balance, get_pool_token_balance, swap, add_demo_token, init_pool

from starkware.cairo.common.cairo_builtins import HashBuiltin

const CALLER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;

// @dev test that pool balance is zero
@external
func test_pool_balance_is_zero{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar tokenA = 1;
    let (balance) = get_pool_token_balance(tokenA);
    assert balance = 0;
    return ();
}

// @dev test that pool initialization works
@external
func test_pool_initialization{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar tokenA = 1;
    tempvar tokenB = 2;

    // intialize pool with 10000000 for token A and B
    init_pool(10000000, 10000000);

    // check that pool balance was updated
    let (balanceA) = get_pool_token_balance(tokenA);
    let (balanceB) = get_pool_token_balance(tokenB);

    assert balanceA = 10000000;
    assert balanceB = 10000000;

    // try to initalize pool with an amount greater than 2**30, expect transaction to revert
    %{ expect_revert("TRANSACTION_FAILED", "exceeds maximum allowed tokens!") %}
    init_pool(1000000000000000, 1000000000000000);

    return ();
}

// @dev test that adding demo tokens works
@external
func test_add_demo_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar token_a_amount = 150;
    tempvar token_b_amount = 300;

    %{ stop_prank_callable = start_prank(ids.CALLER) %}
    add_demo_token(token_a_amount, token_b_amount);
    %{ stop_prank_callable() %}

    // check account balance of address for both tokens was updated
    let (token_a_balance) = get_account_token_balance(CALLER, 1);
    let (token_b_balance) = get_account_token_balance(CALLER, 2);

    assert token_a_balance = 150;
    assert token_b_balance = 300;

    return ();
}

// @dev test swapping functionality
@external
func test_swapping{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // intialize pool with 10000000 for token A and B
    init_pool(10000, 10000);

    // add tokens to account
    %{ stop_prank_callable = start_prank(ids.CALLER) %}
    add_demo_token(100, 250);

    // try swapping from tokenA to tokenB
    let (token_b_received) = swap(1, 50);
    assert token_b_received = 49; //due to decimals.

    // try swapping from tokenB to tokenA
    let (token_a_received) = swap(2, 200);
    assert token_a_received = 198;

    %{ stop_prank_callable() %}
    return ();
}