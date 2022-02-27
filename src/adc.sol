/*
ANGELDUST COIN by Alexander Abraham.
Licensed under the MIT license.
*/

// SPDX-License-Identifier: UNLISCENSED
pragma solidity 0.8.7;
contract ERC20Token {
    uint public oneTokenInWei = 27000000.00;
    string public name = "ANGELDUSTCOIN";
    uint public constant _cap = 100000000;
    string public symbol = "ADC";
    uint256 public totalSupply = 50000000000000000000000000;
    uint8 public decimals = 18;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }
    function setEthPrice(uint _etherPrice) onlyOwner {
      oneTokenInWei = 1 ether * 2 / _etherPrice / 100;
      changed(msg.sender);
    }
    function createTokens() payable{
    require(
        msg.value > 0
        && totalSupply < _cap
        && CROWDSALE_PAUSED <1
        );

        uint multiplier = 10 ** decimals;
        uint256 tokens = msg.value.mul(multiplier) / oneTokenInWei;

        balances[msg.sender] = balances[msg.sender].add(tokens);
        _totalSupply = _totalSupply.add(tokens);
        owner.transfer(msg.value);
    }
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
