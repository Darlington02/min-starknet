%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func names(address) -> (name: felt) {
}

@event
func stored_name(address: felt, name: felt){
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_name: felt) {
    let (caller) = get_caller_address();
    names.write(caller, _name);

    return ();
}

@external
func store_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_name: felt){
  let (caller) = get_caller_address();
  names.write(caller, _name);
  stored_name.emit(caller, _name);
  return ();
}

@view
func get_name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(_address: felt) -> (name: felt){
 let (name) = names.read(_address);
 return (name,);
}