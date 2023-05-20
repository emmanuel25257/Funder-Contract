// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    

    address public immutable i_owner;
   
    using PriceConverter for uint256;

    //We want to be able to fund this contract and also to be able to withdraw from this contract
    uint256 public AmountValue;


    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;
    event funded(address indexed from, uint256 amount);
    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress){
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable  {
        AmountValue = msg.value;
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "Didn't get enough funds");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

   
   
    function withdraw() public  onlyOwner{
        
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) 
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //reset the array

        funders = new address[](0);
        (bool callSuccess,) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner{
        require(msg.sender == i_owner, "Sender not the owner");
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}