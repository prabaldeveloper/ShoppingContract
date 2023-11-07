// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

contract StoreStorage {

    //mapping for getting supported erc20TokenAddress at store level
    mapping(address => bool) public erc20TokenAddressStore;

    //mapping for getting supported erc721TokenAddress at store level
    mapping(address => bool) public erc721TokenAddressStore;
   
    //status at store level
    mapping(address => uint256) public tokenFreePassStatusStore;

    mapping(string => address) public itemAddress;
    
    string internal storeName;

    string internal storeCompany;

    string internal storeId;
    
    address internal storeOwner;

}