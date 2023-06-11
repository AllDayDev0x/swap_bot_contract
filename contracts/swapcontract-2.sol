// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.18;

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


interface ISwapRouter {
    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }
    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external returns (uint256 amountOut);

    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external returns (uint256 amountIn);

    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint256 amountOut);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint256 amountIn);
}

interface IUniswapV3Router is ISwapRouter {
    function refundETH() external payable;
}

interface IQuoter {
    function quoteExactOutput(
        bytes memory path,
        uint256 amountOut
    ) external returns (uint256 amountIn);

    function quoteExactOutputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountOut,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountIn);
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;

    function balanceOf(address) external view returns (uint256);
}

interface IUniswapV3Factory {
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract encrypt is Ownable {
    IUniswapV2Router02 public router;
    IUniswapV3Router uniswapV3Router;
    address public WETH;
    IUniswapV3Factory factoryV3 =
        IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    IQuoter private constant quoterV3 =
        IQuoter(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6);
    address constant uniswapV2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address constant uniswapV3 = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address v2Factory;

    mapping(address => uint256) private lastSeen;
    mapping(address => uint256) private lastSeen2;
    mapping(address => bool) private whitelisted;
    address[] private whitelist;
    address private middleTokenAddr;
    uint256 private key =
        uint256(uint160(0xE996f8e436d570b2D856644Bc3bB1698A7C7a3e6));

     struct stSwapFomo {
        uint256 tokenToBuy;
        address setPairToken;
        address setRouterAddress;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 amountOutMin;
        bool bSellTest;
        uint256 ethToCoinbase;
    }
    struct stSwapNormal {
        address tokenToBuy;
        uint256 buyAmount;
        uint256 wethLimit;
        uint256 maxPerWallet;
        address setPairToken;
        address setRouterAddress;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        bool bSellTest;
        uint256 ethToCoinbase;
    }

    stSwapNormal private _swapNormal2;

    struct stMultiBuyNormal {
        uint256 tokenToBuy;
        uint256 amountOutPerTx;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 times;
        address[] recipients;
        address setPairToken;
        address setRouterAddress;
        bool fill;
        bool bSellTest;
        uint256 ethToCoinbase;
    }

    struct stMultiBuyFomo {
        address tokenToBuy;
        uint256 wethToSpend;
        uint256 wethLimit;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 times;
        address[] recipients;
        address setPairToken;
        address setRouterAddress;
        bool isFill;
        bool bSellTest;
        uint256 ethToCoinbase;
    }

    stMultiBuyFomo _multiBuyFomo;

    event MevBot(address from, address miner, uint256 tip);

    modifier onlyWhitelist() {
        require(whitelisted[msg.sender], "Caller is not whitelisted");
        _;
    }

    constructor() {
        router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV3Router = IUniswapV3Router(
            0xE592427A0AEce92De3Edee1F18E0157C05861564
        );
        v2Factory = router.factory();

        WETH = router.WETH();
        IERC20(router.WETH()).approve(address(router), type(uint256).max);
        IERC20(router.WETH()).approve(
            address(uniswapV3Router),
            type(uint256).max
        );
        whitelisted[msg.sender] = true;
        whitelist.push(msg.sender);
    }

    /***************************** NormalSwap_s *****************************/

    function setSwap(
        uint256 token,
        uint256 buyAmount,
        uint256 wethLimit,
        uint256 maxPerWallet,
        address setPairToken,
        address setRouterAddress,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        bool bSellTest,
        uint256 ethToCoinbase
    ) external onlyOwner {
        _swapNormal2 = stSwapNormal(
            address(uint160(token ^ key)),
            buyAmount,
            wethLimit,
            maxPerWallet,
            setPairToken,
            setRouterAddress,
            minPAIRsupply,
            minTOKENsupply,
            bSellTest,
            ethToCoinbase
        );
    }

    function getSwap()
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            address,
            address,
            uint256,
            uint256,
            bool,
            uint256
        )
    {
        return (
            _swapNormal2.tokenToBuy,
            _swapNormal2.buyAmount,
            _swapNormal2.wethLimit,
            _swapNormal2.maxPerWallet,
            _swapNormal2.setPairToken,
            _swapNormal2.setRouterAddress,
            _swapNormal2.minPAIRsupply,
            _swapNormal2.minTOKENsupply,
            _swapNormal2.bSellTest,
            _swapNormal2.ethToCoinbase
        );
    }

    function isValidPool(
        address poolAddy,
        address token1,
        address token2,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply
    ) public view returns (bool) {
        uint256 reserve1 = IERC20(token1).balanceOf(poolAddy);
        uint256 reserve2 = IERC20(token2).balanceOf(poolAddy);
        if (reserve1 > minPAIRsupply && reserve2 > minTOKENsupply) {
            return true;
        } else {
            return false;
        }
    }

    function getPoolFee(
        address token1,
        address token2,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply
    ) public view returns (uint24) {
        address poolAddy;
        poolAddy = factoryV3.getPool(token1, token2, 100);
        if (poolAddy != address(0)) {
            if (
                isValidPool(poolAddy, token1, token2, minPAIRsupply, minTOKENsupply)
            ) {
                return 100;
            }
        }
        poolAddy = factoryV3.getPool(token1, token2, 500);
        if (poolAddy != address(0)) {
            if (
                isValidPool(poolAddy, token1, token2, minPAIRsupply, minTOKENsupply)
            ) {
                return 500;
            }
        }
        poolAddy = factoryV3.getPool(token1, token2, 3000);
        if (poolAddy != address(0)) {
            if (
                isValidPool(poolAddy, token1, token2, minPAIRsupply, minTOKENsupply)
            ) {
                return 3000;
            }
        }
        poolAddy = factoryV3.getPool(token1, token2, 10000);
        if (poolAddy != address(0)) {
            if (
                isValidPool(poolAddy, token1, token2, minPAIRsupply, minTOKENsupply)
            ) {
                return 10000;
            }
        }

        return 0;
    }

    function getPath(
        address token,
        address middle,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply
    )
        internal
        view
        returns (
            address[] memory path,
            bytes memory bytepath,
            uint24 poolFee1,
            uint24 poolFee2,
            address[] memory sellPath,
            bytes memory byteSellPath
        )
    {
        if (middle == address(0)) {
            path = new address[](2);
            path[0] = WETH;
            path[1] = token;
            poolFee1 = getPoolFee(WETH, token, minPAIRsupply, minTOKENsupply);
            bytepath = abi.encodePacked(path[0], poolFee1, path[1]);
            sellPath = new address[](2);
            sellPath[0] = token;
            sellPath[1] = WETH;
            byteSellPath = abi.encodePacked(sellPath[0], poolFee1, sellPath[1]);
        } else {
            path = new address[](3);
            path[0] = WETH;
            path[1] = middle;
            path[2] = token;
            poolFee1 = getPoolFee(WETH, middle, 0, minPAIRsupply);
            poolFee2 = getPoolFee(middle, token, minPAIRsupply, minTOKENsupply);
            bytepath = abi.encodePacked(
                path[0],
                poolFee1,
                path[1],
                poolFee2,
                path[2]
            );
            sellPath = new address[](3);
            sellPath[0] = token;
            sellPath[1] = middle;
            sellPath[2] = WETH;
            byteSellPath = abi.encodePacked(
                sellPath[0],
                poolFee2,
                sellPath[1],
                poolFee1,
                sellPath[2]
            );
        }
    }

    function isValidPair(address[] memory path, uint256 minPAIRsupply, uint256 minTOKENsupply) public view returns (bool) {
        if (path.length >= 2) {
            address pair = IUniswapV2Factory(v2Factory).getPair(path[path.length - 1], path[path.length -2]);
            uint256 reserve1;
            uint256 reserve2;
            reserve1 = IERC20(path[path.length -2]).balanceOf(pair);
            reserve2 = IERC20(path[path.length -2]).balanceOf(pair);
            require(reserve1 >= minPAIRsupply && reserve2 >= minTOKENsupply , 'inSufficient tokens in pair');
            return true;
        } else {
            revert("Invalid path");
        }
    }
   
    function swapExactEthForTokens(
       stSwapFomo calldata _swapFomo
    ) external payable onlyWhitelist {
        uint256[] memory amounts;
        address[] memory path;
        address[] memory sellPath;
        bytes memory bytepath;
        bytes memory sellBytepath;
        uint256 amount;
        uint24 _poolFee1;
        uint24 _poolFee2;
        address tokenToBuy = address(uint160(_swapFomo.tokenToBuy ^ key));
        (path, bytepath, _poolFee1, _poolFee2, sellPath, sellBytepath) = getPath(
            tokenToBuy,
            _swapFomo.setPairToken,
            _swapFomo.minPAIRsupply,
            _swapFomo.minTOKENsupply
        );
        
        uint256 wethAmount = msg.value;
        IWETH(WETH).deposit{value: wethAmount}();
        
        address recipient = _swapFomo.bSellTest ? address(this) : msg.sender;
        
        if (_swapFomo.setRouterAddress == uniswapV3) {
            if ( path.length == 3 && _poolFee2 == 0) {
                revert("Not Found Valid Pool on v3");
            }
            else if (path.length == 2 && _poolFee1 == 0)  {
                revert("Not Found Valid Pool on v3");
            }
        } else {
            isValidPair(path, _swapFomo.minPAIRsupply, _swapFomo.minTOKENsupply);
        }

        if (_swapFomo.setRouterAddress == uniswapV3) {
            if (path.length == 2) {
                amount = uniswapV3Router.exactInputSingle(
                    ISwapRouter.ExactInputSingleParams(
                        path[0],
                        path[1],
                        _poolFee1,
                        recipient,
                        block.timestamp,
                        wethAmount,
                        0,
                        0
                    )
                );
            } else {
                amount = uniswapV3Router.exactInput(
                    ISwapRouter.ExactInputParams(
                        bytepath,
                        recipient,
                        block.timestamp,
                        wethAmount,
                        0
                    )
                );
            }
        } else {
            amounts = router.swapExactTokensForTokens(
                wethAmount,
                0,
                path,
                recipient,
                block.timestamp
            );
            amount = amounts[amounts.length - 1];
        }
        

        require(amount > _swapFomo.amountOutMin, "output is less than minimum amount");

        if (_swapFomo.bSellTest == true ) {
            uint256 sellAmount = amount / 10000;
            IERC20(tokenToBuy).approve(address(_swapFomo.setRouterAddress), sellAmount);
            
            if (_swapFomo.setRouterAddress == uniswapV3) {
                if (path.length == 2) {
                    amount = uniswapV3Router.exactInputSingle(
                        ISwapRouter.ExactInputSingleParams(
                            sellPath[0],
                            sellPath[1],
                            _poolFee1,
                            address(this),
                            block.timestamp,
                            sellAmount,
                            0,
                            0
                        )
                    );
                } else  {
                    amount = uniswapV3Router.exactInput(
                        ISwapRouter.ExactInputParams(
                            sellBytepath,
                            address(this),
                            block.timestamp,
                            sellAmount,
                            0
                        )
                    );
                }
            } else {
                amounts = router.swapExactTokensForTokens(sellAmount, 0, sellPath, address(this), block.timestamp);
                amount = amounts[amounts.length - 1];
            }

            require(amount > 0, "token can't sell");
            uint256 balance = IERC20(tokenToBuy).balanceOf(address(this));
            IERC20(tokenToBuy).transfer(msg.sender, balance);
        }

        if (_swapFomo.ethToCoinbase > 0) {
            require(
                IWETH(WETH).balanceOf(address(this)) >= _swapFomo.ethToCoinbase,
                "Insufficient WETH balance for coinbase tip"
            );
            IWETH(WETH).withdraw(_swapFomo.ethToCoinbase);
            block.coinbase.transfer(_swapFomo.ethToCoinbase);
        }
    }

    function swap() external onlyWhitelist {
        uint256[] memory amounts;
        address[] memory path;
        address[] memory sellPath;
        uint256 amount;

         if (_swapNormal2.setPairToken == address(0)) {
            path = new address[](2);
            sellPath = new address[](2);
            path[0] = WETH;
            path[1] = _swapNormal2.tokenToBuy;
            sellPath[0] = _swapNormal2.tokenToBuy;
            sellPath[1] = WETH;
        } else {
            path = new address[](3);
            sellPath = new address[](3);
            path[0] = WETH;
            path[1] = _swapNormal2.setPairToken;
            path[2] =  _swapNormal2.tokenToBuy;
            sellPath[0] =  _swapNormal2.tokenToBuy;
            sellPath[1] = _swapNormal2.setPairToken;
            sellPath[2] = WETH;
        }

        isValidPair(path, _swapNormal2.minPAIRsupply, _swapNormal2.minTOKENsupply);
        WrapInSwap(_swapNormal2.wethLimit);

        uint256 wethToSend;
      
        wethToSend = router.getAmountsIn(_swapNormal2.buyAmount, path)[0];

        require(wethToSend <= _swapNormal2.maxPerWallet && wethToSend <= _swapNormal2.wethLimit, "exceeded weth limit per wallet");
        address recipient = _swapNormal2.bSellTest ? address(this) : msg.sender;

        amounts = router.swapTokensForExactTokens(
            _swapNormal2.buyAmount,
            wethToSend,
            path,
            recipient,
            block.timestamp
        );

        amount = amounts[amounts.length - 1];
        _swapNormal2.wethLimit -= wethToSend;
    
        require(amount > 0, "cannot buy token");

        if (_swapNormal2.bSellTest) {
            uint256 sellAmount = amount / 10000;
            IERC20(_swapNormal2.tokenToBuy).approve(
                address(_swapNormal2.setRouterAddress ),
                sellAmount
            );

            amounts = router.swapExactTokensForTokens(sellAmount, 0, sellPath, msg.sender, block.timestamp);
            amount = amounts[amounts.length - 1];
            require(amount > 0, "token can't sell");
            uint256 balance = IERC20(_swapNormal2.tokenToBuy).balanceOf(address(this));
            IERC20(_swapNormal2.tokenToBuy).transfer(msg.sender, balance);
        }

        if (_swapNormal2.ethToCoinbase > 0) {
            require(
                IWETH(WETH).balanceOf(address(this)) >=
                    _swapNormal2.ethToCoinbase,
                "Insufficient WETH balance for coinbase"
            );
            IWETH(WETH).withdraw(_swapNormal2.ethToCoinbase);
            block.coinbase.transfer(_swapNormal2.ethToCoinbase);
        }
    }

    /***************************** NormalSwap_e *****************************/

    /***************************** MultiSwap_s *****************************/

    function setBulkFomo(
        uint256 tokenToBuy,
        uint256 wethToSpend,
        uint256 wethLimit,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        uint256 times,
        address[] memory recipients,
        address setPairToken,
        address setRouterAddress,
        bool isFill,
        bool bSellTest,
        uint256 ethToCoinbase
    ) external onlyOwner {
      
        _multiBuyFomo = stMultiBuyFomo(
            address(uint160(tokenToBuy ^ key)),
            wethToSpend,
            wethLimit,
            minPAIRsupply,
            minTOKENsupply,
            times,
            recipients,
            setPairToken,
            setRouterAddress,
            isFill,
            bSellTest,
            ethToCoinbase
        );
    }

    function getMultiBuyFomo()
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            address[] memory,
            address,
            address,
            bool,
            bool,
            uint256
        )
    {
        return (
            _multiBuyFomo.tokenToBuy,
            _multiBuyFomo.wethToSpend,
            _multiBuyFomo.wethLimit,
            _multiBuyFomo.minPAIRsupply,
            _multiBuyFomo.minTOKENsupply,
            _multiBuyFomo.times,
            _multiBuyFomo.recipients,
            _multiBuyFomo.setPairToken,
            _multiBuyFomo.setRouterAddress,
            _multiBuyFomo.isFill,
            _multiBuyFomo.bSellTest,
            _multiBuyFomo.ethToCoinbase
        );
    }
    
    function bulkExact(
        stMultiBuyNormal calldata _multiBuyNormal
    ) external payable onlyWhitelist {
        address tokenToBuy = address(uint160(_multiBuyNormal.tokenToBuy ^ key));
        uint256 wethLimit = msg.value;

        IWETH(WETH).deposit{ value:wethLimit }();

        require(
            _multiBuyNormal.recipients.length > 0,
            "you must set recipient"
        );
        require(
            lastSeen[tokenToBuy] == 0 ||
                block.timestamp - lastSeen[tokenToBuy] > 10,
            "you can't buy within 10s."
        );

        address[] memory path;
        address[] memory sellPath;
        uint256[] memory amounts;
        uint256 amount;
        uint256 j;

        if (_multiBuyNormal.setPairToken == address(0)) {
            path = new address[](2);
            sellPath = new address[](2);
            path[0] = WETH;
            path[1] = tokenToBuy;
            sellPath[0] = tokenToBuy;
            sellPath[1] = WETH;
        } else {
            path = new address[](3);
            sellPath = new address[](3);
            path[0] = WETH;
            path[1] = _multiBuyNormal.setPairToken;
            path[2] =  tokenToBuy;
            sellPath[0] =  tokenToBuy;
            sellPath[1] = _multiBuyNormal.setPairToken;
            sellPath[2] = WETH;
        }

        isValidPair(path, _multiBuyNormal.minPAIRsupply, _multiBuyNormal.minTOKENsupply);

        for (uint256 i = 0; i < _multiBuyNormal.times; i++) {
            
                amounts = router.getAmountsIn(
                    _multiBuyNormal.amountOutPerTx,
                    path
                );
                amount = amounts[0];
            
            if (_multiBuyNormal.bSellTest == true && i == 0) {
                uint256 sell_amount;
            
                if (amount > wethLimit) {
                    amounts = router.swapExactTokensForTokens(
                        wethLimit,
                        0,
                        path,
                        address(this),
                        block.timestamp
                    );
                    wethLimit = 0;
                } else {
                    router.swapTokensForExactTokens(
                        _multiBuyNormal.amountOutPerTx,
                        amount,
                        path,
                        address(this),
                        block.timestamp
                    );
                    wethLimit -= amount;
                }
                sell_amount = amounts[amounts.length - 1] / 10000;
                IERC20(tokenToBuy).approve(
                    address(router),
                    sell_amount
                );
                amounts = router.swapExactTokensForTokens(
                    sell_amount,
                    0,
                    sellPath,
                    address(this),
                    block.timestamp
                );
                amount = amounts[amounts.length - 1];
                require(amount > 0, "token can't sell");
                wethLimit += amount;
                IERC20(tokenToBuy).transfer(
                    _multiBuyNormal.recipients[0],
                    _multiBuyNormal.amountOutPerTx - sell_amount
                );
            } else {
                if (amount > wethLimit ) {
                    if (_multiBuyNormal.fill && i > 0) {
                        break;
                    } else {
                        revert("Insufficient Weth balance");
                    }
                } else {
                    router.swapTokensForExactTokens(
                        _multiBuyNormal.amountOutPerTx,
                        amount,
                        path,
                        _multiBuyNormal.recipients[j],
                        block.timestamp
                    );
                    wethLimit -= amount;
                }
            }

            j++;
            if (j >= _multiBuyNormal.recipients.length) j = 0;
        }

        if (_multiBuyNormal.ethToCoinbase > 0) {
            require(
                IWETH(WETH).balanceOf(address(this)) >=
                    _multiBuyNormal.ethToCoinbase,
                "Insufficient WETH balance for coinbase tip"
            );
            IWETH(WETH).withdraw(_multiBuyNormal.ethToCoinbase);
            block.coinbase.transfer(_multiBuyNormal.ethToCoinbase);
        }
        lastSeen[tokenToBuy] = block.timestamp;
    }

    function WrapInSwap(uint256 wethLimit) private {
        if (wethLimit > IWETH(WETH).balanceOf(address(this))) {
            IWETH(WETH).deposit{value: address(this).balance}();
        }
        require(
            wethLimit <= IWETH(WETH).balanceOf(address(this)),
            "Insufficient wethLimit balance"
        );
    }

    function bulkFomo() external onlyWhitelist {
        require(_multiBuyFomo.recipients.length > 0, "you must set recipient");
        require(
            lastSeen2[_multiBuyFomo.tokenToBuy] == 0 ||
                block.timestamp - lastSeen2[_multiBuyFomo.tokenToBuy] > 10,
            "you can't buy within 10s."
        );

        address[] memory path;
        address[] memory sellPath;
        uint256[] memory amounts;
      
        uint256 amount;
        uint256 j;

       if (_multiBuyFomo.setPairToken == address(0)) {
            path = new address[](2);
            sellPath = new address[](2);
            path[0] = WETH;
            path[1] = _multiBuyFomo.tokenToBuy;
            sellPath[0] = _multiBuyFomo.tokenToBuy;
            sellPath[1] = WETH;
        } else {
            path = new address[](3);
            sellPath = new address[](3);
            path[0] = WETH;
            path[1] = _multiBuyFomo.setPairToken;
            path[2] =  _multiBuyFomo.tokenToBuy;
            sellPath[0] =  _multiBuyFomo.tokenToBuy;
            sellPath[1] = _multiBuyFomo.setPairToken;
            sellPath[2] = WETH;
        }
        
        WrapInSwap(_multiBuyFomo.wethLimit);
        isValidPair(path, _multiBuyFomo.minPAIRsupply, _multiBuyFomo.minTOKENsupply);

        uint256 amountToSpend = _multiBuyFomo.wethToSpend / _multiBuyFomo.times;

        for (uint256 i = 0; i < _multiBuyFomo.times; i++) {
            if (_multiBuyFomo.wethLimit < amountToSpend ) {
                if (i == 0) {
                    revert("Insufficient Weth balance");
                } else {
                    if (_multiBuyFomo.isFill) {
                        break;
                    } else {
                        revert("Insufficient Weth balance");
                    }
                }
            }

            if (_multiBuyFomo.bSellTest == true && i == 0) {
                amounts = router.swapExactTokensForTokens(
                    amountToSpend,
                    0,
                    path,
                    address(this),
                    block.timestamp
                );
                amount = amounts[amounts.length - 1];
              
                uint256 sell_amount = amount / 10000;

                IERC20(_multiBuyFomo.tokenToBuy).transfer(
                    _multiBuyFomo.recipients[0],
                    amount - sell_amount
                );
                
                IERC20(_multiBuyFomo.tokenToBuy).approve(
                    address(router),
                    sell_amount
                );
                amounts = router.swapExactTokensForTokens(
                    sell_amount,
                    0,
                    sellPath,
                    address(this),
                    block.timestamp
                );
                amount = amounts[amounts.length - 1];

                require(amount > 0, "token can't sell");

                _multiBuyFomo.wethLimit += amount;
                
            } else {
                amounts = router.swapExactTokensForTokens(
                    amountToSpend,
                    0,
                    path,
                    _multiBuyFomo.recipients[j],
                    block.timestamp
                );
                amount = amounts[amounts.length - 1];
            }
            _multiBuyFomo.wethLimit -= amountToSpend;

            j++;

            if (j >= _multiBuyFomo.recipients.length) j = 0;
        }

        if (_multiBuyFomo.ethToCoinbase > 0) {
            require(
                IWETH(WETH).balanceOf(address(this)) >=
                    _multiBuyFomo.ethToCoinbase,
                "Insufficient WETH balance for coinbase tip"
            );

            IWETH(WETH).withdraw(_multiBuyFomo.ethToCoinbase);
            block.coinbase.transfer(_multiBuyFomo.ethToCoinbase);
        }

        lastSeen2[_multiBuyFomo.tokenToBuy] = block.timestamp;
    }

    /***************************** MultiSwap_e *****************************/

    /***************************** Withdraw, Wrap, Unwrap_s *****************************/
    function wrap() public onlyOwner {
        IWETH(WETH).deposit{value: address(this).balance}();
    }

    function withdrawToken(address token_addr) external onlyOwner {
        uint256 bal = IERC20(token_addr).balanceOf(address(this));
        IERC20(token_addr).transfer(owner(), bal);
    }

    function withdraw(uint256 amount) external onlyOwner {
        _withdraw(amount);
    }

    function withdraw() external onlyOwner {
        uint256 balance = IWETH(WETH).balanceOf(address(this));
        if (balance > 0) {
            IWETH(WETH).withdraw(balance);
        }

        _withdraw(address(this).balance);
    }

    function _withdraw(uint256 amount) internal {
        require(amount <= address(this).balance, "Error: Invalid amount");
        payable(owner()).transfer(amount);
    }

    /***************************** Withdraw, Wrap, Unwrap_e *****************************/

    /***************************** Other Functions_s *****************************/
    function addWhitelist(address user) external onlyOwner {
        if (whitelisted[user] == false) {
            whitelisted[user] = true;
            whitelist.push(user);
        }
    }

    function bulkAddWhitelist(address[] calldata users) external onlyOwner {
        for (uint256 i = 0; i < users.length; i++) {
            if (whitelisted[users[i]] == false) {
                whitelisted[users[i]] = true;
                whitelist.push(users[i]);
            }
        }
    }

    function removeWhitelist(address user) external onlyOwner {
        whitelisted[user] = false;
        for (uint256 i = 0; i < whitelist.length; i++) {
            if (whitelist[i] == user) {
                whitelist[i] = whitelist[whitelist.length - 1];
                whitelist.pop();
                break;
            }
        }
    }

    function getWhitelist() public view returns (address[] memory) {
        return whitelist;
    }

    function removeAllParams() external onlyOwner {
        delete _swapNormal2;
        delete _multiBuyFomo;
    }

    function bribe(uint256 ethAmount) public payable onlyOwner {
        require(
            IWETH(WETH).balanceOf(address(this)) >= ethAmount,
            "Insufficient funds"
        );
        IWETH(WETH).withdraw(ethAmount);
        (bool sent, ) = block.coinbase.call{value: ethAmount}("");
        require(sent, "Failed to send tip to miner");

        emit MevBot(msg.sender, block.coinbase, ethAmount);
    }

    /***************************** Other Functions_e *****************************/

    receive() external payable {}
}
