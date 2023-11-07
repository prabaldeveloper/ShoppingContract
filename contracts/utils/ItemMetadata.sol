// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "../utils/ItemERC721.sol";

/**
 * @notice A mixin to extend the OpenZeppelin metadata implementation.
 */
contract ItemMetadata is ItemERC721 {

    /**
     * @notice Allows a creator to mint an NFT.
     */
    function _mintInternal(address ownerAddress, string memory tokenIPFSPath)
        internal
    {
        _mint(ownerAddress, tokenIPFSPath);
    }

    /**
     * @notice Allows the creator to burn if they currently own the NFT.
     */
    function burn(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "ItemMetadata: Invalid owner");
        _burn(tokenId);
    }

    uint256[999] private ______gap;

}
