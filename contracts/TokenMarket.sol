// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ITokenMarket.sol";

contract TokenMarket is ITokenMarket, Ownable {
    IERC20 public token;

    mapping(uint256 => ListRequest) public listings;
    uint256 public listingCounter;

    bytes32 public constant DOMAIN_TYPE_HASH =
        keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    bytes32 public constant LIST_TYPE_HASH = keccak256(
        "list(uint256 _price, uint256 _amount, address _from, address _currency, uint256 deadline, byte signature)"
    );
    
    bytes32 private _domainSeparator;

    constructor(address _tokenAddress) {
        _domainSeparator = keccak256(
            abi.encode(DOMAIN_TYPE_HASH, keccak256(bytes("OstrichMarketplace")), _getChainId(), address(this))
        );
        token = IERC20(_tokenAddress);
    }

    function _verifySignature(ListRequest memory req) private view {
        require(req.deadline >= block.timestamp, "EXPIRED");
        require(req._from != address(0), "INVALID_SELLER");
        bytes32 listHash = keccak256(
            abi.encode(
                LIST_TYPE_HASH,
                req._price,
                req._amount,
                req._from,
                req.deadline
                
            )
        );
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", _domainSeparator, listHash));
        (bytes32 r, bytes32 s, uint8 v) = _splitSignature(req.signature);
        require(ecrecover(digest, v, r, s) == req._from, "INVALID_EIP712_SIGNATURE");
    }

    function _splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function _getChainId() private view returns (uint256) {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        return chainId;
    }

    // Implement the lisitng fuction
    function listing(uint256 _price, uint256 _amount) external {
        require(_price >  0, "Price must be greater than zero");
        require(_amount > 0 , " Amount must be greater than zero" );

        token.transferFrom(msg.sender, address(this), _amount);
        // listings[listingCounter] = ListRequest()
    }

    // Implement the buy function
    function buy(ListRequest memory request, uint256 buyAmount) external payable override {
        
    }

    // Implement the makeOffer function
    function makeOffer(MakeOfferRequest memory request) external payable override {
                
    }
}
