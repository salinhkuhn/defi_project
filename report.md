# Defi Project Report:

Ethereum address associated with the group (i.e., the address used with the faucet which funded all transactions below):

----still have to add---------

## Question 1 (4 points)
a1.) Token address:
a.) Token name: TheMatchaCoin
b.) Token source code (.Sol) : insert directly
c.) Short description of extra functionality of the token:
	As all our group member love the meet up at a cafés and get a matcha we personalized our token such it supports buying a matcha. We have a function that exactly transfer the amount of money needed for matcha at our favourite café. Additionally, our token supports an extra function to transfer the amount needed for a matcha, hence gift a matcha. As those function are not that complex we also implemented a function which allows to change the token name but only if one owns more than half of the token supply.

## Question 2 (--no points--)

## Question 3 (3 points)

### a.) Name of other token in the pair

### b.) Pair contract address

## Question 4 (3 points)

a.) Name of token(s) used to trade for DEFI tokens (separated by comma if more than one)
b.) Amount of tokens needed for the trade

## Question 5 (10 points)

a.) Contract address: 0x9519f326A66CCB392b450eb8e7cEe041999d54F9
a./b.) Contract source code with both functions (.Sol): will add directly 
b.) Brief description of the implementation of the function and steps a user needs to take to call it.
We first saved addresses which are accessed frequently in global variables. Then we implemented the PoolBalance Method which takes two token addresses as input. Using the provided interfaces we first check if such a Pair exists else we print an error message. After having verified the existence of such a pair, hence there is such a pair in our DEX, we queried the balance. In detail we make a function call to .getReserves() which return the amount of token held in the pool. We directly made us of the Pair Interface and its method but returning the reserves could also be done using the balance function of each token.

After implementing PoolBalance we continued with MaxSwap, which atomically executes a trade. As stated in the task our function MaxSwap only return successfully if all the trades where successfully, hence the condition “at most valOfC” holds.
To guarantee such an atomic execution we first preprocessed our “data”. We checked 4 points:
  1.) pair A-B and B-C must exist
        2.) sender must have at least valA of token A -> would say that is als the condition for the user to even call the function 
        3.) router / factory should be allowed to spend valA of the token A 
-> approval
        4.) finally we check that the amount of c we get out doesn’t cross our valOfC restriction
If all of these conditions hold we again used the methods provided by the interface and executed the trades. Finally, we checked once again if the restrictions are not violated.
If a user wants to execute trades using the MaxSwap function only the approval for spending valA of token A must be done, hence to user only has to allow the smartContract to spend valA of token A of the users balance.
	



## Question 6 (possible .25 extra on final exercise grade)
Short description of tactic used to get more WETH (e.g., manual steps or programmed a bot)
(optional) insert a file with source code used




