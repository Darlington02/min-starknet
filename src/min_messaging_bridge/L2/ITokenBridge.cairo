%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace ITokenBridge {
    func set_bridge_l1_address(address: felt) {
    }

    func withdraw_to_l1(amount: Uint256, l1_address: felt) {
    }

    func my_balance(address: felt) -> (balance: Uint256) {
    }
}
