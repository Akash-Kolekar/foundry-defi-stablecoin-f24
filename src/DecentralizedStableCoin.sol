// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DecentralizedStableCoin
 * @author Akash Kolekar
 * Collateral: Exogenous (wETH & wBTC)
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 *
 * This is the contract meant to be governed by DSCEngine. This contract is just the ERC20 implementation of our stablecoin system.
 */
contract DecentralizedStableCoin is ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 ERROR
    //////////////////////////////////////////////////////////////*/
    error DecentralizedStableCoin__AmountMustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();
    error DecentralizedStableCoin__AmountMustBeGreaterThanZero();

    address private immutable i_owner;

    constructor(address _owner) ERC20("DecentralizedStableCoin", "DSC") {
        i_owner = _owner;
    }

    function burn(uint256 _amount) external {
        require(i_owner == msg.sender, "Only owner can burn");
        uint256 balance = balanceOf(msg.sender);
        //Use == instead for <= for uints when comparing for zero values
        if (_amount == 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        if (_amount > balance) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        _burn(msg.sender, _amount);
    }

    function mint(address _to, uint256 _amount) external returns (bool) {
        require(i_owner == msg.sender, "Only owner can mint");
        // if (_to == address(0)) {
        //     revert DecentralizedStableCoin__NotZeroAddress();
        // }
        if (_amount == 0) {
            revert DecentralizedStableCoin__AmountMustBeGreaterThanZero();
        }
        _mint(_to, _amount);
        return true;
    }

    function owner() external view returns (address) {
        return i_owner;
    }
}
