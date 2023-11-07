// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


contract StoreFactoryStorage {
    
    mapping(string => address) public storeAddress;
    
    //mapping for getting supported erc20TokenAddress at master level
    mapping(address => bool) public erc20TokenAddressMaster;

    //mapping for getting supported erc721TokenAddress at master level
    mapping(address => bool) public erc721TokenAddressMaster;
   
    //status at master level
    mapping(address => uint256) public tokenFreePassStatusMaster;

    // Deviation Percentage
    uint256 internal deviationPercentage;

    //platformFeePercent
    uint256 internal platformFeePercent;



   
    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;

}
