%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.min_ico.ico import register, claim, is_registered
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address, get_block_timestamp)
from src.min_ico.IICO import IICO

from src.min_erc20.IERC20 import IERC20
from starkware.cairo.common.uint256 import (Uint256, uint256_sub, uint256_add)


// 
// CONSTANTS
// 
const USER = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a91;
const ADMIN = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;

// Constructor Arguments
const NAME = 33551829125767818279950116212;
const SYMBOL = 4999500;
const DECIMALS = 18;


const ICO_DURATION = 86400; //24 hours to seconds

// @dev setup hook to deploy contracts and save address to context
@external
func __setup__{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     tempvar token_A_address;
     tempvar token_B_address;

    
    // deploys the accepted token used for the purchase of the ICO token. Minted into USER address   
    %{ context.token_A_address = deploy_contract("./src/min_erc20/ERC20.cairo", [ids.NAME, ids.SYMBOL, ids.DECIMALS, 10000000000000000, 0, ids.USER]).contract_address %}
    %{ ids.token_A_address = context.token_A_address %}

    // deploys the ICO tokens and mints to the admin address
    %{ context.token_B_address = deploy_contract("./src/min_erc20/ERC20.cairo", [ids.NAME, ids.SYMBOL, ids.DECIMALS, 10000000000000000, 0, ids.ADMIN]).contract_address %}
    %{ ids.token_B_address = context.token_B_address %}
    
    // deploys the ICO contract that allows for registration and claiming of ICO tokens by users.
    %{context.contract_address = deploy_contract("./src/min_ico/ico.cairo", [ids.token_A_address, ids.token_B_address, ids.USER]).contract_address %} 
    
    let (contract_address) = get_contract_address();

    return ();
}


// @dev test register function - register new address and check status
@external
func test_register{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     tempvar contract_address;
     tempvar token_A_address;
    %{ ids.contract_address = context.contract_address %}
    %{ ids.token_A_address = context.token_A_address %}

     // pranks USER to approve the ICO contract of the accepted token before register function is called
    %{ stop_prank_callable = start_prank(ids.USER, ids.token_A_address) %}
    IERC20.approve(token_A_address, contract_address, Uint256(1000000000000000, 0));
    %{ stop_prank_callable() %}

    // User registers and status is checked.
     %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    IICO.register(contract_address);
    let (balOfContractAddr) = IERC20.balanceOf(token_A_address, contract_address);
    let (status) = IICO.is_registered(contract_address, USER);
    assert status = 1;
    assert balOfContractAddr.low = 1000000000000000;
    %{ stop_prank_callable() %}  
    return();
} 

// @dev test claim function - check that user holds 20 ICO token after claim and claim status is 1.
@external
func test_claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    tempvar token_A_address;
    tempvar token_B_address;
    %{ ids.contract_address = context.contract_address %}
    %{ ids.token_A_address = context.token_A_address %}
    %{ ids.token_B_address = context.token_B_address %}

    // Admin of the ICO contract first funds the contract that disperses ICO tokens
    // supposing that users pays the required registration fee.
    %{ stop_prank_callable = start_prank(ids.ADMIN, ids.token_B_address) %}
    IERC20.transfer(token_B_address, contract_address, Uint256(1000000000000000, 0));
    let (balOfContractAddr) = IERC20.balanceOf(token_B_address, contract_address);
    assert balOfContractAddr.low = 1000000000000000;
    %{ stop_prank_callable() %}

     // pranks USER to approve the ICO contract of the accepted token before register function is called
    %{ stop_prank_callable = start_prank(ids.USER, ids.token_A_address) %}
    IERC20.approve(token_A_address, contract_address, Uint256(1000000000000000, 0));
    %{ stop_prank_callable() %}

    // USER registers and claims 20 ICO tokens.
     %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    IICO.register(contract_address);
    let (balOfContractAddr) = IERC20.balanceOf(token_A_address, contract_address);
    assert balOfContractAddr.low = 1000000000000000;

    // Warp time in order to claim after ICO duration is over.
    let (current_time) = get_block_timestamp();
    let warp_time = current_time + ICO_DURATION;
     %{ stop_warp = warp(ids.warp_time, ids.contract_address) %}
    IICO.claim(contract_address, USER);
    let (bt) = get_block_timestamp();
     %{ stop_warp() %}
    assert bt + ICO_DURATION = warp_time;

    // confirm that user holds expected 20 ICO token after claiming.
    let (bal_of_ico_token) = IERC20.balanceOf(token_B_address, USER);
    assert bal_of_ico_token.low = 20;
    %{ stop_prank_callable() %}
    
    return();
} 

// --------------------- TEST FOR POSSIBLE REVERTS IN ICO CONTRACT ----------------------//

// Test for possible reverts for register function
// @dev test for reverts when USER fails to approve ICO contract the required REG fee
@external
func test_failing_of_register_for_nonApproval{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     alloc_locals;
     tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}


    %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    %{ expect_revert(error_message="ICO: You need to approve at least 0.001 ETH for registration!") %}
    
    IICO.register(contract_address);
    %{ stop_prank_callable() %}
    return();
} 

// @dev test for reverts when USER already registered.
@external
func test_failing_for_already_registered{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     alloc_locals;
     tempvar contract_address;
     tempvar token_A_address;
    %{ ids.contract_address = context.contract_address %}
    %{ ids.token_A_address = context.token_A_address %}

        // USER approves ICO contract 1000000000000000 tokens 
    %{ stop_prank_callable = start_prank(ids.USER, ids.token_A_address) %}
    IERC20.approve(token_A_address, contract_address, Uint256(1000000000000000, 0));
    %{ stop_prank_callable() %}


     %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    IICO.register(contract_address);

    %{ expect_revert(error_message="ICO: You have already registered!") %}
    IICO.register(contract_address);

    %{ stop_prank_callable() %}
    return();
} 

// @dev test for reverts when unregistered USER attempts to claim ICO tokens
@external
func test_failing_when_unregistered_claim{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     alloc_locals;
     tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}  

    let (admin) = get_caller_address();

    %{expect_revert(error_message="ICO: You are not eligible for this ICO")%}
    IICO.claim(contract_address, admin);
    return();
}

// @dev test for reverts when registered USER attempts to claim before ICO duration is over 
@external
func test_failing_when_claim_before_ICO_time{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     tempvar contract_address;
     tempvar token_A_address;
     tempvar token_B_address;
    %{ ids.contract_address = context.contract_address %}
    %{ ids.token_A_address = context.token_A_address %}
    %{ ids.token_B_address = context.token_B_address %}

     // approve 1000000000000000 tokens as USER to TEST_ACC1
    %{ stop_prank_callable = start_prank(ids.USER, ids.token_A_address) %}
    IERC20.approve(token_A_address, contract_address, Uint256(1000000000000000, 0));
    %{ stop_prank_callable() %}


     %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    IICO.register(contract_address);
    let (balOfContractAddr) = IERC20.balanceOf(token_A_address, contract_address);
    assert balOfContractAddr.low = 1000000000000000;
     %{expect_revert(error_message="ICO: You can only claim tokens after the ICO is over!")%}
    IICO.claim(contract_address, USER);
    %{ stop_prank_callable() %}

    return();
} 

// @dev test for reverts when USER attempts to claim twice 
@external
func test_failing_when_claimed_already{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    tempvar contract_address;
    tempvar token_A_address;
    tempvar token_B_address;
    %{ ids.contract_address = context.contract_address %}
    %{ ids.token_A_address = context.token_A_address %}
    %{ ids.token_B_address = context.token_B_address %}

    // Admin of the ICO contract first funds the contract that disperses ICO tokens
    // supposing that users pays the required registration fee.
    %{ stop_prank_callable = start_prank(ids.ADMIN, ids.token_B_address) %}
    IERC20.transfer(token_B_address, contract_address, Uint256(1000000000000000, 0));
    let (balOfContractAddr) = IERC20.balanceOf(token_B_address, contract_address);
    assert balOfContractAddr.low = 1000000000000000;
    %{ stop_prank_callable() %}

     // pranks USER to approve the ICO contract of the accepted token before register function is called
    %{ stop_prank_callable = start_prank(ids.USER, ids.token_A_address) %}
    IERC20.approve(token_A_address, contract_address, Uint256(1000000000000000, 0));
    %{ stop_prank_callable() %}

    // USER registers and claims 20 ICO tokens.
     %{ stop_prank_callable = start_prank(ids.USER, ids.contract_address) %}
    IICO.register(contract_address);
    let (balOfContractAddr) = IERC20.balanceOf(token_A_address, contract_address);
    assert balOfContractAddr.low = 1000000000000000;

    // Warp time in order to claim after ICO duration is over.
    let (current_time) = get_block_timestamp();
    let warp_time = current_time + ICO_DURATION;
     %{ stop_warp = warp(ids.warp_time, ids.contract_address) %}
    IICO.claim(contract_address, USER);


     %{expect_revert(error_message="ICO: You have already claimed your tokens!")%}
    IICO.claim(contract_address, USER);
    let (bt) = get_block_timestamp();
     %{ stop_warp() %}
    assert bt + ICO_DURATION = warp_time;

    // confirm that user holds expected 20 ICO token after claiming.
    let (bal_of_ico_token) = IERC20.balanceOf(token_B_address, USER);
    assert bal_of_ico_token.low = 20;
    %{ stop_prank_callable() %}
    
    return();
} 



// @dev test is_registered function -  the status of an unregistered address 
@external
func test_status_for_unregistered_address{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
     tempvar contract_address;
    %{ ids.contract_address = context.contract_address %}
    let (admin) = get_caller_address();

    let (status) = IICO.is_registered(contract_address, admin);
    assert status = 0;
    return();
}

