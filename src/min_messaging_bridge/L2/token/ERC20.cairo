%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from cairo_contracts.src.openzeppelin.token.erc20.library import ERC20
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.bool import TRUE

// 
// CONSTRUCTOR
// 

// @dev intitialized on deployment
// @param _name the ERC20 token name
// @param _symbol the ERC20 token symbol
// @param _decimals the ERC20 token decimals
// @param initialSupply a Uint256 representation of the token initial supply
// @param recipient the token owner
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _name: felt, _symbol: felt, _decimals: felt, initialSupply: Uint256, recipient: felt
){
    ERC20.initializer(_name, _symbol, _decimals);
    ERC20._mint(recipient, initialSupply);
    return ();
}

// 
// GETTERS
// 

// @dev get name of the token
// @return the name of the token
@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    let (name) = ERC20.name();
    return (name,);
}

// @dev get the symbol of the token
// @return symbol of the token
@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    let (symbol) = ERC20.symbol();
    return (symbol,);
}

// @dev get the decimals of the token
// @return decimal of the token
@view
func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (decimals: felt) {
    let (decimals) = ERC20.decimals();
    return (decimals,);
}

// @dev get the total supply of the token
// @return total supply of the token
@view
func totalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (totalSupply: Uint256) {
    let (totalSupply) = ERC20.total_supply();
    return (totalSupply,);
}

// @dev get the token balance of an address
// @param account Account whose balance is to be queried
// @return the balance of the account
@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (balance: Uint256) {
    let (balance) = ERC20.balance_of(account);
    return (balance,);
}

// @dev returns the allowance to an address
// @param owner the account whose token is to be spent
// @param spender the spending account
// @return remaining the amount allowed to be spent
@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(owner: felt, spender: felt) -> (remaining: Uint256) {
    let (allowance) = ERC20.allowance(owner, spender);
    return (allowance,);
}

// 
// SETTERS
// 

// @dev carries out ERC20 token transfer
// @param recipient the address of the receiver
// @param amount the Uint256 representation of the transaction amount
// @return success the status of the transaction
@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    recipient: felt, amount: Uint256
) -> (success: felt) {
    ERC20.transfer(recipient, amount);
    return (TRUE,);
}

// @dev transfers token on behalf of another account
// @param sender the from address
// @param recipient the to address
// @param amount the amount being sent
// @return success the status of the transaction
@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    sender: felt, recipient: felt, amount: Uint256
) -> (success: felt) {
    ERC20.transfer_from(sender, recipient, amount);
    return (TRUE,);
}

// @dev approves token to be spent on your behalf
// @param spender address of the spender
// @param amount amount being approved for spending
// @return success the status of the transaction
@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    spender: felt, amount: Uint256
) -> (success: felt) {
    ERC20.approve(spender, amount);
    return (TRUE,);
}