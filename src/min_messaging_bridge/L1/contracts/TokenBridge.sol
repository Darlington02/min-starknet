// SPDX-License-Identifier: MIT

// this contract should be able to set the l1_token to be bridged.
// this contract should have a public function for withdrawing to L2
// this contract should have public function for depositing to l1
// this contract have a getter function for querying token balance

pragma solidity ^0.8.0;

import "./token/IERC20.sol";
import "./IStarknetCore.sol";

contract ERC20Bridge {
    IStarknetCore starknetCore;
    IERC20 ERC20;
    uint256 public bridge_l2_address;
    uint256 public constant DEPOSIT_SELECTOR = 1186453342039699482468091468567902583489149327554289572395482112898188943818;
    address public bridgeContractAdmin;

    modifier onlyOwner {
        require(msg.sender == bridgeContractAdmin);
        _;
    }

    constructor(IStarknetCore starknetCore_, uint256 bridge_l2_address_, address bridgeContractAdmin_) {
        starknetCore = starknetCore_;
        bridge_l2_address = bridge_l2_address_;
        bridgeContractAdmin = bridgeContractAdmin_;
    }

    function set_l1_token(IERC20 l1_token_address) public onlyOwner {
        ERC20 = l1_token_address;
    }
    
    function withdraw_to_l2(address l2_user_address) external payable {
        uint256 user_balance = ERC20.balanceOf(msg.sender);
        require(user_balance >= msg.value, "TOKEN_BRIDGE: The specified amount exceeds your balance!");
        ERC20.burn(msg.sender, msg.value);

        uint256 l2_address_as_uint256 = uint256(uint160(l2_user_address));
        uint256[] memory payload = new uint256[](2);
        payload[0] = l2_address_as_uint256;
        payload[1] = msg.value;

        starknetCore.sendMessageToL2(bridge_l2_address, DEPOSIT_SELECTOR, payload);
    }

    function deposit_to_l1(uint256 amount) public {
        uint256 caller_as_uint256 = uint256(uint160(msg.sender));

        uint256[] memory payload = new uint256[](2);
        payload[0] = caller_as_uint256;
        payload[1] = amount;

        starknetCore.consumeMessageFromL2(bridge_l2_address, payload);

        ERC20.mint(msg.sender, amount);
    }

    function my_balance() public view returns (uint256) {
        uint256 balance = ERC20.balanceOf(msg.sender);
        return (balance);
    }
}