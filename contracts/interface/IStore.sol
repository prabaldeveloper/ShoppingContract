// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;

interface IStore{
    function getOwner() external view returns(address);
}