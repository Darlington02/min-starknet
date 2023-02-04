#[contract]

mod AMM {
    use starknet::get_caller_address;

    const BALANCE_UPPER_BOUND: felt = 1048284;
    const POOL_UPPER_BOUND: felt = 103748;
    const ACCOUNT_BALANCE_BOUND: felt = 1073741;
    const TOKEN_TYPE_A: felt = 1;
    const TOKEN_TYPE_B: felt = 2;

    struct Storage {
        account_balance: LegacyMap::<(felt, felt), felt>,
        pool_balance: LegacyMap::<felt, felt>,
    }

    // @dev returns account balance for a given token
    // @param account_id Account to be queried
    // @param token_type Token to be queried
    #[view]
    fn get_account_token_balance(account_id: felt, token_type: felt) -> felt {
        account_balance::read((account_id, token_type))
    }

    // @dev return the pool's balance
    // @param token_type Token type to get pool balance
    #[view]
    fn get_pool_token_balance(token_type: felt) -> felt {
        pool_balance::read(token_type)
    }

    // @dev set pool balance for a given token
    // @param token_type Token whose balance is to be set
    // @param balance Amount to be set as balance
    #[external]
    fn set_pool_token_balance(token_type: felt, balance: felt) {
        assert((BALANCE_UPPER_BOUND - 1) > balance, 'exceeds maximum allowed tokens!');

        pool_balance::write(token_type, balance)
    }

    // @dev add demo token to the given account
    // @param token_a_amount amount of token a to be added
    // @param token_b_amount amount of token b to be added
    #[external]
    fn add_demo_token(token_a_amount: felt, token_b_amount: felt) {
        let account_id = get_caller_address();

        modify_account_balance(account_id, TOKEN_TYPE_A, token_a_amount);
        modify_account_balance(account_id, TOKEN_TYPE_B, token_b_amount)
    }

    // @dev intialize AMM
    // @param token_a amount of token a to be set in pool
    // @param token_b amount of token b to be set in pool
    #[external]
    fn init_pool(token_a: felt, token_b: felt) {
        assert(((POOL_UPPER_BOUND - 1) > token_a) & ((POOL_UPPER_BOUND - 1) > token_b), 'exceeds maximum allowed tokens!');

        set_pool_token_balance(TOKEN_TYPE_A, token_a);
        set_pool_token_balance(TOKEN_TYPE_B, token_b)
    }

    // @dev swaps token between the given account and the pool
    // @param token_from token to be swapped
    // @param amount_from amount of token to be swapped
    // @return amount_to the token swapped to
    #[external]
    fn swap(token_from: felt, amount_from: felt) -> felt {
        let account_id = get_caller_address();

        assert(token_from - TOKEN_TYPE_A == 0 | token_from - TOKEN_TYPE_B == 0, 'token not allowed in the pool!');
        assert((BALANCE_UPPER_BOUND - 1) > amount_from, 'exceeds maximum allowed tokens');
        let account_from_balance = get_account_token_balance(account_id, token_from);
        assert(account_from_balance > amount_from, 'Insufficient balance!');

        let token_to = get_opposite_token(token_from);
        let amount_to = do_swap(account_id, token_from, token_to, amount_from);
        return (amount_to);
    }

    // @dev internal function that updates account balance for a given token
    // @param account_id Account whose balance is to be modified
    // @param token_type Token type to be modified
    // @param amount Amount Amount to be added
    fn modify_account_balance(account_id: felt, token_type: felt, amount: felt) {
        let current_balance = account_balance::read((account_id, token_type));
        let new_balance = current_balance + amount;

        assert((BALANCE_UPPER_BOUND - 1) > new_balance, 'exceeds maximum allowed tokens');

        account_balance::write((account_id, token_type), new_balance)
    }

    // @dev internal function to get the opposite token type
    // @param token_type Token whose opposite pair needs to be gotten
    fn get_opposite_token(token_type: felt) -> felt {
        if (token_type == TOKEN_TYPE_A) {
            return TOKEN_TYPE_B;
        } else {
            return TOKEN_TYPE_A;
        }
    }

    // @dev internal function that swaps tokens between the given account and the pool
    // @param account_id Account whose tokens are to be swapped
    // @param token_from Token type to be swapped from
    // @param token_to Token type to be swapped to
    // @param amount_from Amount to be swapped
    fn do_swap(account_id: felt, token_from: felt, token_to: felt, amount_from: felt) -> felt {
        let amm_from_balance = get_pool_token_balance(token_from);
        let amm_to_balance = get_pool_token_balance(token_to);
        //let amount_to = (amm_to_balance * amount_from) / (amm_from_balance + amount_from); this is uncommented cause div is yet to be implemented, we'd use a dummy instead
        let amount_to = 45;

        modify_account_balance(account_id, token_from, (0 - amount_from)); // (0 - amount_from) is same as -amount_from 
        modify_account_balance(account_id, token_to, amount_to);
        set_pool_token_balance(token_from, (amm_from_balance + amount_from));
        set_pool_token_balance(token_to, (amm_to_balance - amount_to));

        return (amount_to);
    }
}