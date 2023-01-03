%lang starknet

@contract_interface
namespace IAMM {
    func get_account_token_balance(account_id: felt, token_type: felt) -> (balance: felt) {
    }

    func get_pool_token_balance(token_type: felt) -> (balance: felt) {
    }

    func set_pool_token_balance(token_type: felt, balance: felt) {
    }

    func add_demo_token(token_a_amount: felt, token_b_amount: felt) {
    }

    func init_pool(token_a: felt, token_b: felt) {
    }

    func swap(token_from: felt, amount_from: felt) -> (amount_to: felt) {
    }
}
