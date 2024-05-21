// SPDX-License-Identifier: XXX 
//idk for what we need the above  but else I get an error

pragma solidity >=0.8.18;
/**
 * @title SmartContractTask5
 * @author Sarah Kuhn&Khushii Gupta

 */
import "DefiClass-main/interfaces/IERC20.sol";
import "DefiClass-main/interfaces/IFactory.sol";
import "DefiClass-main/interfaces/IRouter.sol";
import "DefiClass-main/interfaces/IPair.sol";

 
 contract SmartContractTask5{
    //global vaariables&constants
    address factory = 0x0Ca73866dFf0f6b0508F5Cbb223C857C19463e07;
    address router = 0x5DA88dF55AF2E5681D33f36e5916d63797BF4766;
    //are constant given in the task but as we will use them often we make save the address. -> MaxSwap and getPoolBalance will use it often
    
    
    
    //Task 5a "A view function called PoolBalance which takes in two token addresses to get the pool balances of a pair of tokens in our DEX."

    function PoolBalance(address tA, address tB) public view returns(uint256 balanceOfA, uint256 balanceOfB){
        
        address addressOfPoolOfPair = IUniswapV2Factory(factory).getPair(tA,tB);
        require(addressOfPoolOfPair != address(0), 'Invalid trading pair'); //adress 0x00000000 would be an invalid pair hence we dont want that 
        
        //read out the balances using the methods provded via the interface
        (balanceOfA, balanceOfB, ) = IUniswapV2Pair(addressOfPoolOfPair).getReserves();
    }

    //Task 5b -> goal is to write a function MaxSwap that takes in valA of token A and swaps it to toke C via an intermediate token B
    //we want at most valC of token C

    //!!! swap should be atomic as stated in the task, hence all or nothing

    /* what shoud be my preconditions such that the swap should execute and will fulfill the conditions
        1.) pair A-B and B-C must exist
        2.) sender must have at least valA of token A -> would say that is als the condition for the user to even call the function 
        3.) router / factory should be allowed to spend valA of the token A -> approval
        4.) finally we check that the amount of c we get out doesnt cross our valOfc restirction -> nice function in the router interface :function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    */

    function MaxSwap(address A, address B, address C, uint256 valA, uint256 valC) public {
        
        //addresses I use over and over 
        address thisContract=address(this);
        address sender=msg.sender;

        //1.) check that the trading pairs exist
        address A_pair_B=IUniswapV2Factory(factory).getPair(A, B);
        address B_pair_C=IUniswapV2Factory(factory).getPair(B, C);
        require(A_pair_B!=address(0), 'Abort because trading pair A-B doesnt exist');
        require(B_pair_C!=address(0), 'Abort because trading pair B-C doesnt exist');

        //2.) check that sender has enough balance to even start the trade
        uint256 senderBalanceOfA=IERC20(A).balanceOf(sender);
        require(valA<=senderBalanceOfA,'Sender does not have enough balance of token A');

        //3.) check router and factoryy are allowed to send to this contract aka from sender to contract  
        require(IERC20(A).allowance(msg.sender, thisContract)>=valA,'Are not allowed to send valA to this contract');  

        //4.) check that if I  would execute the contract the ouput would maximal be valC of token C
        //we can use the getOut function from the router interace which intakes a whole swapping path

        //prep
        address[] memory trades = new address [] (3); //As we go from A to B to C
        trades[0] = A; trades [1] = B; trades[2] = C;
        
        //check
        //getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts); from interface 
        uint256[] memory amountsOut = IUniswapV2Router01(router).getAmountsOut(valA,trades);
        uint256 amountOfCOut = amountsOut[2];
        require(amountOfCOut<=valC, 'The trade would output a to high value of C');
        
        //5.) if we reach here everything should be fine and we can execute the trade
        //give approval to perform the swaps
        IERC20(A).approve(router, valA);
        IERC20(A).approve(factory, valA);
        //official start it by providng this contract with enough balance
        IERC20(A).transferFrom(msg.sender, thisContract, valA); // we checked it earlier so should be fine

        //SWAP using function: swapExactTokensForTokens(uint amountIn,uint amountOutMin,address[] calldata path,address to,uint deadline) external returns (uint[] memory amounts);
        uint deadline= block.timestamp +45000; //set this more or less randomly, is in seconds 15*3
        uint[] memory finalOutputOfTheTrade = IUniswapV2Router01(router).swapExactTokensForTokens(valA,0, trades, msg.sender ,deadline);

        uint finalCOut= finalOutputOfTheTrade[2];
        require(finalCOut <= valC, 'Still got more than valC when executed f.eg because a front-runner.....');
    }
 }
