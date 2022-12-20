
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import (Uint256, uint256_sub)
from starkware.starknet.common.messages import send_message_to_l1
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)

from src.min_messaging_bridge.L2.token.IERC20 import IERC20

// 
// STORAGE VARIABLES
//

// @dev address of erc20 token on layer2
@storage_var
func token_l2_address() -> (address: felt) {
}

// @dev address of bridge on layer1
@storage_var
func bridge_l1_address() -> (address: felt) {
}

// @dev address of bridge admin
@storage_var
func admin() -> (address: felt) {
}


// 
// CONSTRUCTOR
// 

// @dev initialized on deployment
// @param l2_address address of erc20 token on layer2
// @param admin_address address of the bridge admin
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    l2_address: felt, admin_address: felt
) {
    token_l2_address.write(l2_address);
    admin.write(admin_address);

    return ();
}

// 
// EXTERNALS
// 

// @dev sets the bridge l1 address. Can be done by only the bridge admin
// @param address of token bridge on l1
@external
func set_bridge_l1_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) {
    // check that caller is the contract admin
    with_attr error_message("BRIDGE: This function can only be called by the contract admin!"){
        let (admin_address) = admin.read();
        let (caller) = get_caller_address();
        assert caller = admin_address;
    }

    bridge_l1_address.write(address);
    return ();
}

// @dev withdraws or sends token to an l1 address
// @param amount amount of tokens to be withdrawn
// @param l1_address l1 address where the tokens should be sent
@external
func withdraw_to_l1{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    amount: Uint256, l1_address: felt
) {
    alloc_locals;
    let (caller) = get_caller_address();
    let (this_contract) = get_contract_address();
    let (l2_token_address) = token_l2_address.read();
    let (l1_bridge_address) = bridge_l1_address.read();
    
    // lock the tokens from the caller's wallet in bridge contract
    IERC20.transferFrom(l2_token_address, caller, this_contract, amount);

    // send message to l1
    let (message_payload: felt*) = alloc();
    assert message_payload[0] = l1_address;
    assert message_payload[1] = amount.low;
    assert message_payload[2] = amount.high;
    send_message_to_l1(l1_bridge_address, 3, message_payload);

    return ();
}

// 
// L1 HANDLERS
// 

// @dev L1 handler to deposit funds into layer2.
// @param from_address the l1 bridge contract address.
// @param user_address the l2 user to receive the funds.
// @param amount_low the low part of the amount (in uint256).
// @param amount_high the high part of the amount (in uint256).
@l1_handler
func deposit_to_l2{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_address: felt, user_address: felt, amount_low: felt, amount_high: felt
) {
    let (l1_bridge_address) = bridge_l1_address.read();
    let (l2_token_address) = token_l2_address.read();
    with_attr error_message("BRIDGE: The L1 address is incorrect!"){
        assert from_address = l1_bridge_address;
    }

    // transfer amount from locked bridge tokens to the user
    let amount = Uint256(amount_low, amount_high);
    IERC20.transfer(l2_token_address, user_address, amount);

    return ();
}

// 
// GETTERS
// 

// @dev returns the erc20 balance of an address
// @param address the address whose balance is to be queried
// @returns the balance of the address
@view
func my_balance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (balance: Uint256) {
    let (token_address) = token_l2_address.read();

    let (balance) = IERC20.balanceOf(token_address, address);
    return (balance,);
}