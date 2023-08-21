// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ITokenMarket.sol";
// import "./TokenProxy.sol";

contract TokenMarket is ITokenMarket {
    mapping(address => ListRequest) public listings;
    uint256 public listingCounter;

    bytes32 public constant DOMAIN_TYPE_HASH =
        keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    bytes32 public constant LIST_TYPE_HASH = keccak256(
        "list(uint256 _price, uint256 _quantity, address _from, address _currency, uint256 deadline, byte signature)"
    );
    
    bytes32 private _domainSeparator;

    /*  
        Pass to contract address
        @param _tokenAddress
    */
    constructor() {
        _domainSeparator = keccak256(
            abi.encode(DOMAIN_TYPE_HASH, keccak256(bytes("OstrichMarketplace")), _getChainId(), address(this))
        );
        // token = ERC20(_tokenAddress);
    }

    

    // function _verifySignature(ListRequest memory req) private view {
    //     require(req.deadline >= block.timestamp, "EXPIRED");
    //     require(req._from != address(0), "INVALID_SELLER");
    //     bytes32 listHash = keccak256(
    //         abi.encode(
    //             LIST_TYPE_HASH,
    //             req.tokenAddress,
    //             req._price,
    //             req._quantity,
    //             req._from,
    //             req.deadline   
    //         )
    //     );
    //     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _domainSeparator, listHash));
    //     (bytes32 r, bytes32 s, uint8 v) = _splitSignature(req.signature);
    //     require(ecrecover(digest, v, r, s) == req._from, "INVALID_EIP712_SIGNATURE");
    // }

    // function _splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
    //     require(sig.length == 65, "invalid signature length");
    //     assembly {
    //         r := mload(add(sig, 32))
    //         s := mload(add(sig, 64))
    //         v := byte(0, mload(add(sig, 96)))
    //     }
    // }

    // function getSignatureComponents(bytes memory signature) public pure returns (bytes32 r, bytes32 s, uint8 v) {
    //     return _splitSignature(signature);
    // }

    function _getChainId() public view returns (uint256) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return chainId;
    }

    // Implement the lisitng fuction
    function listing(uint256 _price, uint256 _quantity, address _tokenAddress) external {
        require(_price >  0, "Price must be greater than zero");
        require(_quantity > 0 , " Amount must be greater than zero" );
        require(_tokenAddress != address(0), "Invalid token address");
        ERC20 token = ERC20(_tokenAddress);

        if(_getBlanceContract(token) > 0) {
            token.transferFrom(msg.sender, address(this), _quantity);
            listings[msg.sender] = ListRequest(_tokenAddress, _price, _quantity, msg.sender);
        }
    }

    function _checkAllowance(address _tokenAddress) external view returns (uint256) {
        ERC20 token = ERC20(_tokenAddress);
        return token.allowance(msg.sender , address(this));
    }

    function _getBlanceContract(ERC20 _tokenAddress) public view returns (uint256) {
        return _tokenAddress.balanceOf(msg.sender);
    }

    function _getMsgSender() public view returns (address) {
        return msg.sender;
    }

    function _getAddressThis() public view returns(address) {
        return address(this);
    }

    // Implement the buy function
    function buy(ListRequest memory request, uint256 buyAmount) external payable override {
        
    }

    function _buy(ListRequest memory request, uint256 buyAmount) private {
        
    }

    // Implement the makeOffer function
    function makeOffer(MakeOfferRequest memory request) external payable override {
                
    }
}
