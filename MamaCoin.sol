pragma solidity 0.8.25;

import "DefiClass-main/interfaces/IERC20.sol";
import "SafeMath.sol";


///copied the provided ERC20 token contract 
contract SarahKhushiiCoin is IERC20{
    using SafeMath for uint256; ///wanna adapt this to the actual ints we are using.

    string public constant name = 'MatchaCoin';
    string public constant symbol = 'MaMa';
    uint8 public constant decimals = 3;
    uint  public  _totalSupply = 40*10**6; ///SUPPLY OF 4O Million
    
    ///changed this function to private as I dont see any reayon for them to be public, will only call the from within the contract
    mapping(address => uint) private  _balances;
    mapping(address => mapping(address => uint)) private _allowance;
    
    mapping(address => uint) private nonces;/// we can still discuss if our token needs a nonce 

    //did not change this so we can let it be taken from the interface, no need to have it here 
    /**event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);*/

    
    /** this method initzilazes the smart contract, only call it once when deploying, the smart contract deployer gets the totalSupply, so will be holder of all the tokens 
    emit: signals that from address 0 to the caller a transfer happend-> helps other to track what happend*/
    
    constructor(){
            _balances[msg.sender]= _totalSupply;
            emit Transfer(address(0), msg.sender, _totalSupply);
    }


    function allowance (address from, address spender) public override view returns (uint256){
    return _allowance[from][spender];
    }
    ///inserted saftey checks + delete the from attribute as we should anyways only send from the token holder to others 
    function transfer(address to, uint256 value) public override returns (bool) {
    require(value <= _balances[msg.sender], "Insufficient balance");
    require(to != address(0), "Invalid recipient address");
    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);

    emit Transfer(msg.sender, to, value); // Include the value parameter as the third argument

    return true;
}

    ///here we approve others to spend our token, just added saftey checks 
    function approve(address spender, uint256 value) public override returns (bool) {
        require(spender != address(0),"Invalid recipient address");
        _allowance[msg.sender][spender] = value;
        emit Approval(msg.sender,spender, value);
        return  true;
    }

    //instead of having nested calls like in the inteerface we define one directly 
    function _transfer(address from, address to, uint256 value) private {
        _balances[from] =  _balances[from].sub(value);
        _balances[to] =  _balances[to].add(value);
        emit Transfer (from, to, value);
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require( to != address(0),"Invalid recipient address"); ///dont allow to burn here 
        require(value<= _allowance[from][msg.sender]);
        require(value<=_balances[from]);

        _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);///obv less allowed now 
        _transfer(from,msg.sender, value);
        return true;
    }
function balanceOf(address owner) external view returns (uint){
    return _balances[owner];
}

function totalSupply() external view returns (uint){
    return _totalSupply;
}

//added some extra functions 

function allowMore() public {

}

function allowLess() public {

}

function buyAMatcha(address to, uint256 price) public returns (Bool) {
    ///matcha should always be less than 8 fr
    require(price<= 8.0, "don't buy it, it's to expensive rather go to Joeys");
    require(to !=address(0));
    transferFrom(msg.sender, to, price);
    return true;
}

}
