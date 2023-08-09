// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ITokenMarket {
    struct ListRequest {
        uint256 _price;
        uint256 _amount;
        address _from; 
        address _currency;
        uint256 deadline;
        bytes signature;
    }

    struct TransferRequest {
        uint256 _token;
        uint256 _amount;
        address _from;
        address _to;
    }

    struct MakeOfferRequest {
        uint256 _price;
        uint256 _amount;
        address _currency;
        uint duration;
    }


    function buy(ListRequest memory request, uint256 buyAmount) external payable;
    function makeOffer(MakeOfferRequest memory request) external payable ;

}