%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_signed_nn_le)
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.starknet.common.syscalls import (get_caller_address, get_contract_address)

from src.min_erc721.IERC721 import IERC721
from src.min_erc20.IERC20 import IERC20

// 
// STRUCTS
// 

// @dev Parameters for Listing
// @tokenContract the contract of the token to be listed
// @tokenId the ID of the token to be listed
// @seller the caller of the function
// @price the asking price for the token on marketplace
struct Listing {
    tokenContract: felt,
    tokenId: Uint256,
    seller: felt,
    price: felt,
}

// CONSTANTS
const ETH_CONTRACT = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;

// 
// STORAGE VARIABLES
// 

// @dev stores the mapping of listing id to the token listing struct
@storage_var
func all_listings(id: felt) -> (token: Listing) {
}

// @dev stores the sale status for each token listing
// @notice stores a bool value, where 0 represents not sold and 1 represents sold
@storage_var
func listing_sale_status(id: felt) -> (bool: felt) {
}

// @dev keeps count of total listings
@storage_var
func listing_counter() -> (idx: felt) {
}

// 
// EVENTS
// 

// @dev event emitted when listing is created
@event
func listing_created(token: Listing) {
}

// @dev event emitted when listing is sold
@event
func listing_sold(buyer: felt, token: Listing) {
}

// 
// GETTERS
// 

// @dev function to get listing details for a particular listing
// @param listing_id the id of the listing whose details is needed
// @returns listing the token listing details
@view
func get_listing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    listing_id: felt
) -> (listing: Listing) {
    let (listing) = all_listings.read(listing_id);
    return (listing,);
}

// @dev function to get the sale status for a listing
// @param listing_id the id of the listing whose sale status is needed
// @returns status a bool value showing the sale status (0 = not sold, 1 = sold)
@view
func get_sale_status{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    listing_id: felt
) -> (status: felt) {
    let (status) = listing_sale_status.read(listing_id);
    return (status,);
}

// @dev function to get the total listings on the market
// @returns total_listings the number of total tokens listed on the market
@view
func get_total_listings{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (total_listings: felt) {
    let (total_listings) = listing_counter.read();
    return (total_listings,);
}

// 
// EXTERNALS
// 

// @dev function to list token on marketplace
// @param token_contract_address contract address of token to be listed
// @param token_id id of token to be listed
// @param price the asking price to be paid for token
// @notice Remember to call setApprovalForAll(<address of this contract>, true) on the ERC721's contract before calling this function
@external
func list_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_contract_address: felt, token_id: Uint256, price: felt
) {
    // get caller address
    let (caller) = get_caller_address();

    // create token listing
    let listing = Listing(token_contract_address, token_id, caller, price);

    // transfer listed token ownership to this contract
    let (this_contract) = get_contract_address();
    IERC721.transferFrom(token_contract_address, caller, this_contract, token_id);

    // update available_listing
    let (prevIndex) = listing_counter.read();
    let index = prevIndex + 1;
    all_listings.write(index, listing);

    // update listing_counter and emit event
    listing_counter.write(index);
    listing_created.emit(listing);

    return ();
}

// @dev function to purchase a token listed on market
// @param listing_id id of listing to be purchased
// @notice Remember to call approve(<address of this contract>, amount to be spent) on ETH's Starknet contract before calling this function
@external
func buy_token{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    listing_id: felt
) {
    alloc_locals;
    let (buyer) = get_caller_address();
    let (this_contract) = get_contract_address();
    let (listing) = get_listing(listing_id);
    let listing_price_in_uint = Uint256(listing.price, 0);
    let token_id = listing.tokenId;
    let seller = listing.seller;

    // check listing exists
    with_attr error_message("NFTMarket: Listing does not exist"){
        let listing_exists = is_not_zero(seller);
        assert listing_exists = 1;
    }

    // check listing is not sold yet
    with_attr error_mesage("NFTMarket: Listing has already been sold!"){
        let (is_sold) = get_sale_status(listing_id);
        assert 0 = is_sold;
    }
    
    // check that the user has beforehand approved the address of the ICO contract to spend the listing price from his ETH balance
    with_attr error_message("ICO: You need to approve the listing price in ETH to be spent!"){
        let (approved) = IERC20.allowance(ETH_CONTRACT, buyer, this_contract);
        let (less_than) = uint256_signed_nn_le(listing_price_in_uint, approved);
        assert less_than = 1;
    }

    // accept eth from buyer
    IERC20.transferFrom(ETH_CONTRACT, buyer, this_contract, listing_price_in_uint);

    // set listing status to sold
    listing_sale_status.write(listing_id, 1);

    // transfer eth to seller
    IERC20.transfer(ETH_CONTRACT, seller, listing_price_in_uint);

    // transfer token to buyer
    let token_contract_address = listing.tokenContract;
    IERC721.transferFrom(token_contract_address, this_contract, buyer, token_id);

    // emit token listing sold
    listing_sold.emit(buyer, listing);

    return ();
}
