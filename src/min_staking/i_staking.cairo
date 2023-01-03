%lang starknet

from starkware.cairo.common.uint256 import Uint256
from src.min_staking.staking import Stake

@contract_interface
namespace IStaking {
    func stake(stake_amount: Uint256, duration_in_secs: felt) {
    }

    func claim_rewards(stake_id: felt) {
    }

    func total_stakes() -> (total: felt) {
    }

    func stake_information(stake_id: felt) -> (stake: Stake) {
    }

    func stake_total_returns(stake_id: felt) -> (amount: Uint256) {
    }
}
