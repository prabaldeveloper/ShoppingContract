// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;
import "./utils/StoreStorage.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "./Item.sol";

contract Store is StoreStorage, Initializable {
    
    event Erc20TokenUpdated(string storeId, address indexed tokenAddress, bool status, string name, string symbol, uint256 decimal);

    event Erc721TokenUpdated(string storeId,address indexed tokenAddress, bool status, uint256 freePassStatus,
    string name, string symbol, uint256 decimal);

    event ItemCreated(address itemContract, string name, string symbol, uint256 totalSupply,string storeId);

    modifier onlyOwner() {
        require(msg.sender == storeOwner, "Store: Invalid Caller");
        _;
    }

    constructor(string memory _storeName, string memory _storeCompany, string memory _storeId, address _storeOwner) {
        storeName = _storeName;
        storeCompany = _storeCompany;
        storeId = _storeId;
        storeOwner = _storeOwner;
    }

    function createItemContracts(string memory name, string memory symbol, uint256 totalSupply, string memory skuCode, address _ownerAddress) external onlyOwner() {
        address itemContract;
        itemContract = address(new Item(name, symbol, totalSupply, skuCode, _ownerAddress));
        require(itemAddress[skuCode] == address(0), "Store: SKU Code must be unique");
        itemAddress[skuCode] = itemContract;
        emit ItemCreated(itemContract, name, symbol, totalSupply, skuCode);
    }

    function transferOwnership(address _newOwner) public {
         require(
            _newOwner != address(0),
            "Store: new owner is the zero address"
        );
        storeOwner = _newOwner;
    }

    function whitelistErc20TokenAddressStore(address tokenAddress, bool status) external onlyOwner {
        erc20TokenAddressStore[tokenAddress] = status;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC20");
         emit Erc20TokenUpdated(storeId, tokenAddress, status, name, symbol, decimal);

    }

    ///@notice Add supported Erc-721 tokens for the payment at store level
    function whitelistErc721TokenAddressStore(address tokenAddress, bool status, uint256 freePassStatus) external onlyOwner{
        erc721TokenAddressStore[tokenAddress] = status;
        tokenFreePassStatusStore[tokenAddress] = freePassStatus;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC721");
        emit Erc721TokenUpdated(storeId, tokenAddress, status, freePassStatus, name, symbol, decimal);
    }

    ///@notice Returns whitelisted status of erc20TokenAddress at store level
    function isErc20TokenWhitelistedMaster(address tokenAddress) public view returns (bool) {
        return erc20TokenAddressStore[tokenAddress];
    }

    ///@notice Returns whitelisted status of erc721TokenAddress at store level
    function isErc721TokenWhitelistedMaster(address tokenAddress) public view returns (bool) {
        return erc721TokenAddressStore[tokenAddress];
    }

    ///@notice Returns freepass status of erc721TokenAddress at store level
    function isErc721TokenFreePass(address tokenAddress) public view returns (uint256) {
        return tokenFreePassStatusStore[tokenAddress];
    }

    function getTokenDetails(address _tokenAddress, string memory tokenType) internal view returns(string memory , string memory, uint256) {
        if(keccak256(abi.encodePacked((tokenType))) == keccak256(abi.encodePacked(("ERC721")))) {
            string memory _name =  IERC721MetadataUpgradeable(_tokenAddress).name();
            string memory _symbol = IERC721MetadataUpgradeable(_tokenAddress).symbol();
            return (_name, _symbol, 0);
        }
        else { 
            if(_tokenAddress!= address(0)) {
                string memory _name = IERC20Metadata(_tokenAddress).name();
                string memory _symbol = IERC20Metadata(_tokenAddress).symbol();
                uint256 _decimal = IERC20Metadata(_tokenAddress).decimals();
                return ( _name, _symbol, _decimal);
            }
            else {
                return ("Matic", "Matic", 18);
            }
        }
    }

    function getStoreOwner() public view returns(address) {
        return storeOwner;
    }

}