%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from cairo_contracts.src.openzeppelin.token.erc721.library import ERC721
from cairo_contracts.src.openzeppelin.introspection.erc165.library import ERC165
from cairo_contracts.src.openzeppelin.access.ownable.library import Ownable

// 
// STORAGE VARIABLES
// 
@storage_var
func token_counter() -> (id: felt) {
}


// 
// CONSTRUCTOR
// 

// @dev initialized on deployment
@constructor 
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
    name: felt, symbol: felt, owner: felt
) {
    ERC721.initializer(name, symbol);
    Ownable.initializer(owner);
    return ();
}

// 
// GETTERS
// 

// @dev check for interface support
@view
func supportsInterface{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (
    interfaceId: felt
) -> (success: felt) {
    let (success) = ERC165.supports_interface(interfaceId);
    return (success,);
}

// @dev get name of token
// @return name of the token
@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} () -> (name: felt) {
    let (name) = ERC721.name();
    return (name,);
}

// @dev get symbol of token
// @return symbol of the token
@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} () -> (symbol: felt) {
    let (symbol) = ERC721.symbol();
    return (symbol,);
}

// @dev get balance of an account
// @param owner account to be queried
// @return balance of account
@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (owner: felt) -> (balance: Uint256) {
    let (balance: Uint256) = ERC721.balance_of(owner);
    return (balance,);
}

// @dev get owner of token
// @param tokenId ID of token to be queried
// @return owner of token
@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (tokenId: Uint256) -> (owner: felt) {
    let (owner) = ERC721.owner_of(tokenId);
    return (owner,);
}

// @dev Get the approved address for a single token
// @param tokenId ID of token to be queried
// @return the approved address
@view
func getApproved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (tokenId: Uint256) -> (approved: felt) {
    let (approved) = ERC721.get_approved(tokenId);
    return (approved,);
}

// @dev Query if an address is an authorized operator for another address
// @param owner address of token owner
// @param operator address of authorized operator to be queried
// @return True or False, depending on if the queried address is an authorized operator
@view
func isApprovedForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr} (owner: felt, operator: felt) -> (isApproved: felt) {
    let (isApproved) = ERC721.is_approved_for_all(owner, operator);
    return (isApproved,);
}

// 
// EXTERNALS
// 

// @dev approve address to spend token
// @param account address to be approved
// @param ID of token to be spent 
@external
func approve{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt, tokenId: Uint256
) {
    ERC721.approve(account, tokenId);
    return ();
}

// @dev Enable or disable approval for an operator to manage all caller's asset
// @param operator address to be set or removed
// @param approved True if the operator is approved, false if not
@external
func setApprovalForAll{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    operator: felt, approved: felt
) {
    ERC721.set_approval_for_all(operator, approved);
    return ();
}

// @dev Transfer token ownership from one account to another
// @param _from current owner of token
// @param to the new owner to be transferred to
// @param tokenId ID of token to be transferred
@external
func transferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _from: felt, to: felt, tokenId: Uint256
) {
    ERC721.transfer_from(_from, to, tokenId);
    return ();
}

// @dev Transfer token ownership from one account to another
// @param _from the current owner of token
// @param to the new owner to be transferred to
// @param tokenId ID of token to be transferred
// @param data_len length of additional data
// @param data additional data sent in call to "to"
@external
func safeTransferFrom{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    _from: felt, to: felt, tokenId: Uint256, data_len: felt, data: felt*
) {
    ERC721.safe_transfer_from(_from, to, tokenId, data_len, data);
    return ();
}

// @dev mint new tokens to an address
// @param to the address to mint new tokens to
// @notice this function can only be called  by the contract owner
@external
func mint{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt
) {
    Ownable.assert_only_owner();

    let (prevTokenId) = token_counter.read();
    let tokenId = prevTokenId + 1;
    ERC721._mint(to, Uint256(tokenId, 0));
    token_counter.write(tokenId);

    return ();
}