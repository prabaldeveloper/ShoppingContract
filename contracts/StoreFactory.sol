// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.18;
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./access/Ownable.sol";
import "./utils/StoreFactoryStorage.sol";
import "./Store.sol";


contract StoreFactory is 
    Ownable,
    StoreFactoryStorage {
    
    event Erc20TokenUpdated(uint256 indexed masterTokens, address indexed tokenAddress, bool status, string name, string symbol, uint256 decimal);

    event Erc721TokenUpdated(uint256 indexed eventTokenId,address indexed tokenAddress, bool status, uint256 freePassStatus,
    string name, string symbol, uint256 decimal);

    event StoreCreated(address storeContract, string storeName, string storeCompany, string storeId, address storeOwner);

    ///@param platformFeePercent platformFeePercent
    event PlatformFeeUpdated(uint256 platformFeePercent);

    function initialize(address _onwerAddress) public initializer {
        Ownable.ownable_init(_onwerAddress);
    }

    function createStore(string memory storeName, string memory storeCompany, string memory storeId, address storeOwner) external onlyOwner {
        address storeContract;
        storeContract = address(new Store(storeName, storeCompany, storeId, storeOwner));
        require(storeAddress[storeId] == address(0), "StoreFactory: StoreId must be unique");
        storeAddress[storeId] = storeContract;
        emit StoreCreated(storeContract, storeName, storeCompany, storeId, storeOwner);

    }

    ///@notice updates platformFeePercent
    ///@param _platformFeePercent platformFeePercent
    function updatePlatformFee(uint256 _platformFeePercent) external onlyOwner {
        platformFeePercent = _platformFeePercent;
        emit PlatformFeeUpdated(_platformFeePercent);
    }

    function whitelistErc20TokenAddressMaster(address tokenAddress, bool status) external onlyOwner {
        erc20TokenAddressMaster[tokenAddress] = status;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC20");
         emit Erc20TokenUpdated(0, tokenAddress, status, name, symbol, decimal);

    }

    ///@notice Add supported Erc-721 tokens for the payment at master level
    function whitelistErc721TokenAddressMaster(address tokenAddress, bool status, uint256 freePassStatus) external onlyOwner{
        erc721TokenAddressMaster[tokenAddress] = status;
        tokenFreePassStatusMaster[tokenAddress] = freePassStatus;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC721");
        emit Erc721TokenUpdated(0, tokenAddress, status, freePassStatus, name, symbol, decimal);

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

    ///@notice Returns whitelisted status of erc20TokenAddress at master level
    function isErc20TokenWhitelistedMaster(address tokenAddress) public view returns (bool) {
        return erc20TokenAddressMaster[tokenAddress];
    }

    ///@notice Returns whitelisted status of erc721TokenAddress at master level
    function isErc721TokenWhitelistedMaster(address tokenAddress) public view returns (bool) {
        return erc721TokenAddressMaster[tokenAddress];
    }

    ///@notice Returns freepass status of erc721TokenAddress at master level
    function isErc721TokenFreePass(address tokenAddress) public view returns (uint256) {
        return tokenFreePassStatusMaster[tokenAddress];
    }

    ///@notice Returns platformFeePercent
    function getPlatformFeePercent() public view returns (uint256) {
        return platformFeePercent;
    }
}