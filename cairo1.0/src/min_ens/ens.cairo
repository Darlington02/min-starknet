#[contract]

mod ENS {
    // @dev library imports
    use starknet::get_caller_address;

    // @dev storage variables
    struct Storage{
        names: LegacyMap::<felt, felt>,
    }

    // @dev emitted each time a name is stored
    #[event]
    fn StoredName(address: felt, name: felt) {}

    // @dev initialized on contract deployment (not necessary in a real life case, but demonstrates how to write constructors)
    #[constructor]
    fn constructor(_name: felt) {
        let caller = get_caller_address();
        names::write(caller, _name)
    }

    // @dev function to store/attach a name to an address
    // @param _name the name to be stored
    #[external]
    fn store_name(_name: felt) {
        let caller = get_caller_address();
        names::write(caller, _name);
        StoredName(caller, _name)
    }

    // @dev function to get name associated with an address
    // @param _address the address whose name is to be gotten
    #[view]
    fn get_name(_address: felt) -> felt {
        names::read(_address)
    }
}