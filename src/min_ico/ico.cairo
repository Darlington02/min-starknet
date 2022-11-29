%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_add, uint256_sub, uint256_unsigned_div_rem, uint256_signed_nn_le)
from starkware.cairo.common.math_cmp import is_le
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address, get_block_timestamp)
from src.min_erc20.IERC20 import IERC20

// 
// CONSTANTS
// 
const ETH_CONTRACT = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;
const REGPRICE = 1000000000000000;

const ICO_DURATION = 86400; //24 hours to seconds

// 
// STORAGE VARIABLE
// 

// @dev stores the address of the ICO token
@storage_var
func token_address() -> (address: felt) {
}

// @dev stores the ico admin's address
@storage_var
func admin_address() -> (address: felt) {
}

// @notice tracks the registration status of an address
// @dev a map of address to registration status (1 for true, 0 for false)
@storage_var
func registered_address(address: felt) -> (status: felt) {
}

// @notice tracks the claim status of an address to prevent double spending
// @dev a map of address to claim status (1 for true, 0 for false)
@storage_var
func claimed_address(address: felt) -> (status: felt) {
}

// @dev stores the ICO start time
@storage_var
func ico_start_time() -> (start_time: felt) {
}

// @dev stores the ICO end time
@storage_var
func ico_end_time() -> (end_time: felt) {
}


// 
// CONSTRUCTOR
// 

// @dev initialises certain parameters on deployment
// @param tokenAddress address of ICO token
// @param adminAddress address of ICO admin
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenAddress: felt, adminAddress: felt
) {
    admin_address.write(adminAddress);
    token_address.write(tokenAddress);

    // get and store the ico starting and ending time
    let (current_time) = get_block_timestamp();
    let end_time = current_time + ICO_DURATION;
    ico_start_time.write(current_time);
    ico_end_time.write(end_time);

    return ();
}

// EXTERNALS

// @dev registers an address to ICO
@external
func register{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (this_contract) = get_contract_address();
    let (caller) = get_caller_address();
    let (token) = token_address.read();
    let (start_time) = ico_start_time.read();
    let regprice_in_uint = Uint256(REGPRICE, 0);

    // check that ICO has not ended
    with_attr error_message("ICO: This ICO has been completed!"){
        let (current_time) = get_block_timestamp();
        let time_diff = current_time - start_time;
        let less_than = is_le(time_diff, ICO_DURATION);
        assert less_than = 1;
    }

    // check that user is not already registered
    with_attr error_message("ICO: You have already registered!"){
        let (registration_status) = registered_address.read(caller);
        assert registration_status = 0;
    }

    // check that the user has beforehand approved the address of the ICO contract to spend the registration amount from his ETH balance
    with_attr error_message("ICO: You need to approve at least 0.001 ETH for registration!"){
        let (approved) = IERC20.allowance(ETH_CONTRACT, caller, this_contract);
        let (less_than) = uint256_signed_nn_le(regprice_in_uint, approved);
        assert less_than = 1;
    }

    // Transfer the registration price from the caller to the ICO contract address
    IERC20.transferFrom(ETH_CONTRACT, caller, this_contract, regprice_in_uint);

    // add the caller to the list of registered addresses
    registered_address.write(caller, 1);
    return ();
}

// @dev allows a user to claim ICO tokens, by passing in the registered address
// @param address the registered address of the user
@external
func claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) {
    let (is_registered) = registered_address.read(address);

    // check that the ICO is ended
    with_attr error_message("ICO: You can only claim tokens after the ICO is over!"){
        let (start_time) = ico_start_time.read();
        let (current_time) = get_block_timestamp();
        let time_diff = current_time - start_time;
        let less_than = is_le(ICO_DURATION, time_diff);
        assert less_than = 1;
    }

    // check that the caller is registered
    with_attr error_message("ICO: You are not eligible for this ICO"){
        assert is_registered = 1;
    }

    // check that caller has not already claimed
    with_attr error_message("ICO: You have already claimed your tokens!"){
        let (claim_status) = claimed_address.read(address);
        assert claim_status = 0;
    }

    // transfer the claim amount to the user
    let claim_amount = Uint256(20, 0);
    let (this_contract) = get_contract_address();
    let (token) = token_address.read();
    let (admin) = admin_address.read();
    IERC20.transferFrom(token, admin, address, claim_amount);
    
    // add the caller to the list of claimed address to prevent re-claiming
    claimed_address.write(address, 1);
    return ();
}

// GETTERS

// @dev check if an address is registered
// @param address address to be checked
// @returns registration status of address (1 if true, 0 if false)
@view
func is_registered{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    address: felt
) -> (status: felt) {
    let (is_registered) = registered_address.read(address);
    return (status=is_registered);
}
