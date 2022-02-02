/*
ANGELDUST COIN by Alexander Abraham.
Licensed under the MIT license.
*/

// SPDX-License-Identifier: UNLISCENSED
pragma solidity 0.8.7;
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract SMTFaucet {
    IERC20 token;
    address owner;
    mapping(address=>uint256) nextRequestAt;
    uint256 faucetDripAmount = 1;
    constructor (address _smtAddress, address _ownerAddress) {
        token = IERC20(_smtAddress);
        owner = _ownerAddress;
    }
    modifier onlyOwner{
        require(msg.sender == owner,"FaucetError: Caller not owner");
        _;
    }
    function send() external {
        require(token.balanceOf(address(this)) > 1,"FaucetError: Empty");
        require(nextRequestAt[msg.sender] < block.timestamp, "FaucetError: Try again later");
        nextRequestAt[msg.sender] = block.timestamp + (5 minutes);
        token.transfer(msg.sender,faucetDripAmount * 10**token.decimals());
    }
     function setTokenAddress(address _tokenAddr) external onlyOwner {
        token = IERC20(_tokenAddr);
    }
     function setFaucetDripAmount(uint256 _amount) external onlyOwner {
        faucetDripAmount = _amount;
    }
     function withdrawTokens(address _receiver, uint256 _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount,"FaucetError: Insufficient funds");
        token.transfer(_receiver,_amount);
    }
}
