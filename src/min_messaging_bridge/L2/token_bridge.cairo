// this token bridge can be used to send any ERC20 token from an L2 -> L1 and vice versa
// we would create an ERC20 token + interface on both L1 and L2
// the ERC20s should have a mint, burn and bridge_admin functionality
// CAIRO PART:
// the token bridge should have a storage variable, token_l2_address
// the token bridge should have a constructor where the address of the token on both l1 and l2 is initialized.
// it should have an external function, Withdraw that subtracts the balance of the user, then calls the burn function, and submits message to L1
// it should have an l1_handler deposit that is called when someone tries depositing into L2
// it should have a getter function, balance that returns the balance of a user when called.

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

@storage_var
func token_l2_address() -> (address: felt) {
}

@storage_var
func bridge_l1_address() -> (address: felt) {
}

@storage_var
func admin() -> (address: felt) {
}


// 
// CONSTRUCTOR
// 

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
    send_message_to_l1(l1_bridge_address, 2, message_payload);

    return ();
}

// 
// L1 HANDLERS
// 

@l1_handler
func deposit_to_l2{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_address: felt, user_address: felt, amount: Uint256
) {
    let (l1_bridge_address) = bridge_l1_address.read();
    let (l2_token_address) = token_l2_address.read();
    with_attr error_message("BRIDGE: The L1 address is incorrect!"){
        assert from_address = l1_bridge_address;
    }

    // transfer amount from locked bridge tokens to the user
    IERC20.transfer(l2_token_address, user_address, amount);

    return ();
}

// 
// GETTERS
// 

@view
func my_balance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (balance: Uint256) {
    let (token_address) = token_l2_address.read();

    let (balance) = IERC20.balanceOf(token_address, address);
    return (balance,);
}