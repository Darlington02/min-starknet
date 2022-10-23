%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.min_ens.ens import store_name, get_name

const CALLER = 0x00A596deDe49d268d6aD089B56CC76598af3E949183a8ed10aBdE924de191e48;
const NAME = 322918500091226412576622;

// @dev setup hook to deploy contract and save address to context
@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    %{context.address = deploy_contract("./src/min_ens/ens.cairo", [ids.NAME]).contract_address %}

    return ();
}

// @dev test store_name function
@external
func test_store_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // start a prank
    %{ stop_prank = start_prank(ids.CALLER) %}
    // call the store_name function
    store_name(NAME);

    // test for emitted events
    %{ expect_events({"name": "stored_name", "data" : [ids.CALLER, ids.NAME]}) %}

    // stop prank
    %{ stop_prank() %}

    return ();
}

// @dev test get_name function
@external
func test_get_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    // start prank
    %{ stop_prank = start_prank(ids.CALLER) %}
    // call the store_name function
    store_name(NAME);

    // get name from get_name function
    let (name) = get_name(CALLER);
    // assert name is equal to our NAME variable
    assert NAME = name;

    // stop prank
    %{ stop_prank() %}

    return ();
}