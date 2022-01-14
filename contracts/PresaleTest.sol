// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PresaleTest is Ownable, Pausable {
    mapping(address => uint256) userBalance;
    mapping(address => address) public tokenPriceFeedMapping;
    address[] allowedTokens;
    address[] public user;
    IERC20 public preToken;
    uint256 private constant _TIMELOCK = 5 minutes;
    mapping(address => uint256) timeUser;

    constructor(address _mockTokenAddress) public {
        preToken = IERC20(_mockTokenAddress);
    }

    function AddAllowedTokens(address _token) public onlyOwner {
        allowedTokens.push(_token);
    }

    function tokenIsAllowed(address _token) public returns (bool) {
        for (uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++) {
            if(_token == allowedTokens[allowedTokensIndex]) {
                return true;
            }
        }
        return false;
    }

    function setPriceFeedContract(address _token, address _priceFeed) public onlyOwner {
        tokenPriceFeedMapping[_token] = _priceFeed;
    }

    function buyToken(uint256 _amount, address _token) public whenNotPaused {
        require(_amount > 0, "Amount much more than 0");
        require(tokenIsAllowed(_token), "Token is currently not allowed");
        uint256 startTime = block.timestamp;
        uint256 amountPreToken = convertToPretoken(_token, _amount);
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        userBalance[msg.sender] += amountPreToken;
        timeUser[msg.sender] = startTime + _TIMELOCK;
    }

    function convertToPretoken(address _token, uint256 _amount) public view returns(uint256) {
        (uint256 priceInUsd, uint256 decimals) = getTokenValue(_token);
        return ((_amount * priceInUsd / 10**decimals) / 10);
    }

    function getTokenValue(address _token) public view returns(uint256, uint256) {
        // pricefeed
        address priceFeedAddresses = tokenPriceFeedMapping[_token];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(priceFeedAddresses);
        (, int price, , , ) = priceFeed.latestRoundData();
        uint256 decimals = uint256(priceFeed.decimals());
        return (uint256(price), decimals);
    }

    function getAccountToken(address _user) public view returns(uint256) {
        return userBalance[_user];
    }

    function claimToken() public {
        uint256 balance = userBalance[msg.sender];
        uint256 startTime = block.timestamp;
        require(balance > 0, "Staking balance cannot be 0");
        require(startTime >= checkTimelock(msg.sender),"You token not release");
        preToken.transfer(msg.sender, balance);
        userBalance[msg.sender] = 0;
    }

    function checkTimelock(address _user) public view returns(uint256) {
        return timeUser[_user];
    }

    function onwerPause() external onlyOwner whenNotPaused {
        _pause();
    }

    function onwerUnPause() external onlyOwner whenPaused {
        _unpause();
    }
}