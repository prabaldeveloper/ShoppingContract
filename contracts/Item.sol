// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "./utils/ItemMetadata.sol";
import "./interface/IStore.sol";
contract Item is ItemMetadata {
    
    string internal skuCode;
    mapping (address => bool) public signerAddress;

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_, string memory _skuCode, address _onwerAddress) initializer {
        __ERC721_init(name_, symbol_, totalSupply_ );
        skuCode = _skuCode;
        Ownable.ownable_init(_onwerAddress);
    }

    function updateTotalSupply(uint256 _newTotalSupply) external onlyOwner {
        updateTotalSupplyInternal(_newTotalSupply);
    }

    function updateSignerAddress(address _signerAddress, bool _status) external onlyOwner {
        signerAddress[_signerAddress] = _status;
    }

    function mint(address _ownerAddress, string memory _tokenIPFSPath) external onlyOwner {
        require(signerAddress[msg.sender] == true, "Item: Invalid Caller");
        _mintInternal(_ownerAddress, _tokenIPFSPath);
    }
}
