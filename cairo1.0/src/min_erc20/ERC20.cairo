#[contract]
mod ERC20 {
    // @dev library imports
    use starknet::get_caller_address;

    // @dev storage variables
    struct Storage {
        name: felt,
        symbol: felt,
        decimals: u8,
        total_supply: u256,
        balances: LegacyMap::<felt, u256>,
        allowances: LegacyMap::<(felt, felt), u256>,
    }

    // @dev emitted each time a transfer is carried out
    // @param from_ the address of the sender
    // @param to the address of the recipient
    // @param value the amount being sent
    #[event]
    fn Transfer(from_: felt, to: felt, value: u256) {}

    // @dev emitted each time an Approval operation is carried out
    // @param owner the address of the token owner
    // @param spender the address of the spender
    // @param value the amount being approved
    #[event]
    fn Approval(owner: felt, spender: felt, value: u256) {}

    // @dev intitialized on deployment
    // @param name_ the ERC20 token name
    // @param symbol_ the ERC20 token symbol
    // @param decimals_ the ERC20 token decimals
    // @param initial_supply a Uint256 representation of the token initial supply
    // @param recipient the assigned token owner
    #[constructor]
    fn constructor(
        name_: felt, symbol_: felt, decimals_: u8, initial_supply: u256, recipient: felt
    ) {
        name::write(name_);
        symbol::write(symbol_);
        decimals::write(decimals_);
        assert(recipient != 0, 'ERC20: mint to the 0 address');
        total_supply::write(initial_supply);
        balances::write(recipient, initial_supply);
        Transfer(0, recipient, initial_supply);
    }

    // @dev get name of the token
    // @return the name of the token
    #[view]
    fn get_name() -> felt {
        name::read()
    }

    // @dev get the symbol of the token
    // @return symbol of the token
    #[view]
    fn get_symbol() -> felt {
        symbol::read()
    }

    // @dev get the decimals of the token
    // @return decimal of the token
    #[view]
    fn get_decimals() -> u8 {
        decimals::read()
    }

    // @dev get the total supply of the token
    // @return total supply of the token
    #[view]
    fn get_total_supply() -> u256 {
        total_supply::read()
    }

    // @dev get the token balance of an address
    // @param account Account whose balance is to be queried
    // @return the balance of the account
    #[view]
    fn balance_of(account: felt) -> u256 {
        balances::read(account)
    }

    // @dev returns the allowance to an address
    // @param owner the account whose token is to be spent
    // @param spender the spending account
    // @return remaining the amount allowed to be spent
    #[view]
    fn allowance(owner: felt, spender: felt) -> u256 {
        allowances::read((owner, spender))
    }

    // @dev carries out ERC20 token transfer
    // @param recipient the address of the receiver
    // @param amount the Uint256 representation of the transaction amount
    #[external]
    fn transfer(recipient: felt, amount: u256) {
        let sender = get_caller_address();
        transfer_helper(sender, recipient, amount);
    }

    // @dev transfers token on behalf of another account
    // @param sender the from address
    // @param recipient the to address
    // @param amount the amount being sent
    #[external]
    fn transfer_from(sender: felt, recipient: felt, amount: u256) {
        let caller = get_caller_address();
        spend_allowance(sender, caller, amount);
        transfer_helper(sender, recipient, amount);
    }

    // @dev approves token to be spent on your behalf
    // @param spender address of the spender
    // @param amount amount being approved for spending
    #[external]
    fn approve(spender: felt, amount: u256) {
        let caller = get_caller_address();
        approve_helper(caller, spender, amount);
    }

    // @dev increase amount of allowed tokens to be spent on your behalf
    // @param spender address of the spender
    // @param added_value amount to be added
    #[external]
    fn increase_allowance(spender: felt, added_value: u256) {
        let caller = get_caller_address();
        approve_helper(caller, spender, allowances::read((caller, spender)) + added_value);
    }

    // @dev increase amount of allowed tokens to be spent on your behalf
    // @param spender address of the spender
    // @param added_value amount to be added
    #[external]
    fn decrease_allowance(spender: felt, subtracted_value: u256) {
        let caller = get_caller_address();
        approve_helper(caller, spender, allowances::read((caller, spender)) - subtracted_value);
    }

    // @dev internal function that performs the transfer logic
    // @param sender address of the sender
    // @param recipient the address of the receiver
    // @param amount the Uint256 representation of the transaction amount
    fn transfer_helper(sender: felt, recipient: felt, amount: u256) {
        assert(sender != 0, 'ERC20: transfer from 0');
        assert(recipient != 0, 'ERC20: transfer to 0');
        balances::write(sender, balances::read(sender) - amount);
        balances::write(recipient, balances::read(recipient) + amount);
        Transfer(sender, recipient, amount);
    }

    // @dev infinite allowance check
    // @param owner the address of the token owner
    // @param spender the address of the spender
    // @param amount the Uint256 representation of the approved amount
    fn spend_allowance(owner: felt, spender: felt, amount: u256) {
        let current_allowance = allowances::read((owner, spender));
        let ONES_MASK = 0xffffffffffffffffffffffffffffffff_u128;
        let is_unlimited_allowance =
            current_allowance.low == ONES_MASK & current_allowance.high == ONES_MASK;
        if !is_unlimited_allowance {
            approve_helper(owner, spender, current_allowance - amount);
        }
    }

    // @dev internal function that performs the approval logic
    // @param owner the address of the token owner
    // @param spender the address of the spender
    // @param amount the Uint256 representation of the approved amount
    fn approve_helper(owner: felt, spender: felt, amount: u256) {
        assert(spender != 0, 'ERC20: approve from 0');
        allowances::write((owner, spender), amount);
        Approval(owner, spender, amount);
    }
}