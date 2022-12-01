%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import (Uint256, uint256_signed_nn_le, uint256_mul, uint256_add, uint256_unsigned_div_rem)
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address, get_block_timestamp)

from src.min_erc20.IERC20 import IERC20

// 
// CONSTANTS
// 
const YIELD = 5; //meant to be 0.005, but Cairo doesn't work well with decimals, so we'd do the maths later

// 
// STRUCTS
// 
struct Stake{
    address: felt,
    start_time: felt,
    end_time: felt,
    stake_amount: Uint256,
    stake_duration: felt,
    claim_status: felt,
}

// 
// STORAGE VARIABLES
// 

// @dev stores a mapping of stake id to the stake struct
@storage_var
func stake_details(stake_id: felt) -> (stake_info: Stake) {
}

// @dev keeps track of the total stakes, returning the latest count as prev ID
@storage_var
func stake_counter() -> (res: felt) {
}

// @dev stores the address of Staked token
@storage_var
func token_address() -> (address: felt) {
}

// @dev stores the address of contract admin
@storage_var
func admin_address() -> (address: felt) {
}

// 
// CONSTRUCTOR
// 

// @dev initializes certain parameters on deployment
// @param tokenAddress address of token to be staked
// @param adminAddress address of the staking admin (wallet with the funds)
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokenAddress: felt, adminAddress: felt
) {
    alloc_locals;
    token_address.write(tokenAddress);
    admin_address.write(adminAddress);
    
    return ();
}

// 
// EXTERNALS
// 

// @dev function to stake your tokens
// @param stake_amount amount of tokens to be staked
// @param duration_in_secs duration of stake
@external
func stake{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    stake_amount: Uint256, duration_in_secs: felt
) {
    alloc_locals;
    let (caller) = get_caller_address();
    let (this_contract) = get_contract_address();
    let (current_time) = get_block_timestamp();
    let (token) = token_address.read();
    let (prev_stake_id) = stake_counter.read();
    let new_stake_id = prev_stake_id + 1;
    let end_time = current_time + duration_in_secs;

    // check that the user has beforehand approved the address of the staking contract to spend the stake_amount from his token balance
    with_attr error_message("STAKING: You need to approve the inputted stake amount to be spent!"){
        let (approved) = IERC20.allowance(token, caller, this_contract);
        let (less_than) = uint256_signed_nn_le(stake_amount, approved);
        assert less_than = 1;
    }

    // Transfer the stake amount from the caller to the staking contract address
    IERC20.transferFrom(token, caller, this_contract, stake_amount);

    let stake_info = Stake(caller, current_time, end_time, stake_amount, duration_in_secs, 0);

    // update stake details
    stake_details.write(new_stake_id, stake_info);

    // update stake counter
    stake_counter.write(new_stake_id);

    return ();
}

// @dev function to claim rewards after staking time expires
// @param stake_id ID of stake to be claimed
@external
func claim_rewards{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    stake_id: felt
) {
    alloc_locals;
    let (caller) = get_caller_address();
    let (this_contract) = get_contract_address();
    let (admin) = admin_address.read();
    let (current_time) = get_block_timestamp();
    let (token) = token_address.read();
    let (stake_info) = stake_details.read(stake_id);
    let (total_stakes) = stake_counter.read();
    let start_time = stake_info.start_time;
    let end_time = stake_info.end_time;
    let yield_in_uint256 = Uint256(YIELD, 0);

    // check that staking ID is a valid one
    with_attr error_message("STAKING: The stake ID provided is invalid!"){
        let less_than = is_le(stake_id, total_stakes);
        assert less_than = 1;
    }

    // check that the caller is the true owner of the stake
    with_attr error_message("STAKING: You do not own this Stake!"){
        assert stake_info.address = caller;
    }  

    // check that the stake has not been already withdrawn
    with_attr error_message("STAKING: You have already withdrawn this Stake!"){
        assert stake_info.claim_status = 0;
    }   

    // check that the staking duration has ended
    with_attr error_message("STAKING: Your staking duration has not ended!"){
        let less_than = is_le(end_time, current_time);
        assert less_than = 1;
    }

    // calculate total yields and total payment
    let (reward_per_second, _) = uint256_mul(stake_info.stake_amount, yield_in_uint256);
    let stake_duration_in_uint256 = Uint256(stake_info.stake_duration, 0);
    let (reward, _) = uint256_mul(reward_per_second, stake_duration_in_uint256);
    let (reward_percentage, _) = uint256_unsigned_div_rem(reward, Uint256(1000, 0)); //divide by 1000, since yield rate is meant to be 5/1000
    let (total_payment, _) = uint256_add(stake_info.stake_amount, reward_percentage);

    // Transfer the total reward from the staking admin to the caller
    IERC20.transferFrom(token, admin, caller, total_payment);

    let new_stake_info = Stake(stake_info.address, start_time, end_time, stake_info.stake_amount, stake_info.stake_duration, 1);

    // update stake details to show token rewards have been claimed
    stake_details.write(stake_id, new_stake_info);

    return ();
}

// 
// GETTERS
// 

// @dev returns the total stake count
@view
func total_stakes{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (total: felt) {
    let (total) = stake_counter.read();
    return (total,);
}

// @dev get stake details for a particular stake
// @param stake_id ID of stake to be queried
@view
func stake_information{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    stake_id: felt
) -> (stake: Stake) {
    let (stake_info) = stake_details.read(stake_id);
    return (stake_info,);
}

// @dev get the total returns (yield + initial stake) for a particular stake ID
// @param stake_id ID of stake to be queried
@view
func stake_total_returns{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    stake_id: felt
) -> (amount: Uint256) {
    alloc_locals;
    let (stake_info) = stake_details.read(stake_id);
    let yield_in_uint256 = Uint256(YIELD, 0);

    let (reward_per_second, _) = uint256_mul(stake_info.stake_amount, yield_in_uint256);
    let stake_duration_in_uint256 = Uint256(stake_info.stake_duration, 0);
    let (reward, _) = uint256_mul(reward_per_second, stake_duration_in_uint256);
    let (reward_percentage, _) = uint256_unsigned_div_rem(reward, Uint256(1000, 0)); //divide by 1000, since yield rate is meant to be 5/1000
    let (total_payment, _) = uint256_add(stake_info.stake_amount, reward_percentage);

    return (total_payment,);
}