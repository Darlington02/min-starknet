%lang starknet

from src.min_nft_marketplace.nft_market import Listing
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace INftMarket {
    func get_listing(listing_id: felt) -> (listing: Listing) {
    }

    func get_sale_status(listing_id: felt) -> (status: felt) {
    }

    func get_total_listings() -> (total_listings: felt) {
    }

    func list_token(token_contract_address: felt, token_id: Uint256, price: felt) {
    }

    func buy_token(listing_id: felt) {
    }
}
