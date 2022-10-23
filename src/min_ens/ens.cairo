%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

// 
// STORAGE VARIABLES
// 

// @dev stores the mapping of a name to each address
@storage_var
func names(address) -> (name: felt) {
}

// @dev emitted each time a name is stored
@event
func stored_name(address: felt, name: felt){
}

// @dev initialized on contract deployment (not necessary in a real life case, but demonstrates how to write constructors)
@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_name: felt) {
    let (caller) = get_caller_address();
    names.write(caller, _name);

    return ();
}

// @dev function to store/attach a name to an address
// @param _name the name to be stored
@external
func store_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_name: felt){
  let (caller) = get_caller_address();
  names.write(caller, _name);
  stored_name.emit(caller, _name);
  return ();
}

// @dev function to get name associated with an address
// @param _address the address whose name is to be gotten
@view
func get_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_address: felt) -> (name: felt){
 let (name) = names.read(_address);
 return (name,);
}