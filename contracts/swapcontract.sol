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
        address tokenToBuy;
        uint256 wethAmount;
        uint256 wethLimit;
        address setPairToken;
        bool isV3Swap;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 amountOutMint;
        bool bSellTest;
    }
    stSwapFomo private _swapFomo;

    struct stSwapNormal {
        address tokenToBuy;
        uint256 buyAmount;
        uint256 wethLimit;
        uint256 maxPerWallet;
        address setPairToken;
        bool isV3Swap;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        bool bSellTest;
    }

    stSwapNormal private _swapNormal2;

    struct stMultiBuyNormal {
        address tokenToBuy;
        uint256 amountOutPerTx;
        uint256 wethLimit;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 times;
        address[] recipients;
        address setPairToken;
        bool isV3Swap;
        bool fill;
        bool bSellTest;
    }
    stMultiBuyNormal _multiBuyNormal;

    struct stMultiBuyFomo {
        address tokenToBuy;
        uint256 wethToSpend;
        uint256 wethLimit;
        uint256 minPAIRsupply;
        uint256 minTOKENsupply;
        uint256 times;
        address[] recipients;
        address setPairToken;
        bool isV3Swap;
        bool isFill;
        bool bSellTest;
    }

    stMultiBuyFomo _multiBuyFomo;

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

    function setFomo(
        uint256 token,
        uint256 wethAmount,
        uint256 wethLimit,
        address setPairToken,
        bool isV3Swap,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        uint256 amoutnOutMin,
        bool bSellTest
    ) external onlyOwner {
        _swapFomo = stSwapFomo(
            address(uint160(token ^ key)),
            wethAmount,
            wethLimit,
            setPairToken,
            isV3Swap,
            minPAIRsupply,
            minTOKENsupply,
            amoutnOutMin,
            bSellTest
        );
    }

    function setSwap(
        uint256 token,
        uint256 buyAmount,
        uint256 wethLimit,
        uint256 maxPerWallet,
        address setPairToken,
        bool isV3Swap,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        bool bSellTest
    ) external onlyOwner {
        _swapNormal2 = stSwapNormal(
            address(uint160(token ^ key)),
            buyAmount,
            wethLimit,
            maxPerWallet,
            setPairToken,
            isV3Swap,
            minPAIRsupply,
            minTOKENsupply,
            bSellTest
        );
    }

    function getFomo()
        external
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            address,
            bool,
            uint256,
            uint256,
            bool
        )
    {
        return (
            _swapFomo.tokenToBuy,
            _swapFomo.wethAmount,
            _swapFomo.wethLimit,
            _swapFomo.amountOutMint,
            _swapFomo.setPairToken,
            _swapFomo.isV3Swap,
            _swapFomo.minPAIRsupply,
            _swapFomo.minTOKENsupply,
            _swapFomo.bSellTest
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
            bool,
            uint256,
            uint256,
            bool
        )
    {
        return (
            _swapNormal2.tokenToBuy,
            _swapNormal2.buyAmount,
            _swapNormal2.wethLimit,
            _swapNormal2.maxPerWallet,
            _swapNormal2.setPairToken,
            _swapNormal2.isV3Swap,
            _swapNormal2.minPAIRsupply,
            _swapNormal2.minTOKENsupply,
            _swapNormal2.bSellTest
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
        revert("not found valid pool");
    }

    function getV3Path(
        address token,
        address middle,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply
    )
        internal
        view
        returns (
            bytes memory bytepath,
            uint24 poolFee1,
            uint24 poolFee2,
            bytes memory byteSellPath
        )
    {
        if (middle == address(0)) {
            poolFee1 = getPoolFee(WETH, token, minPAIRsupply, minTOKENsupply);
            bytepath = abi.encodePacked(WETH, poolFee1, token);
            byteSellPath = abi.encodePacked(token, poolFee1, WETH);
        } else {
            poolFee1 = getPoolFee(WETH, middle, 0, minPAIRsupply);
            poolFee2 = getPoolFee(middle, token, minPAIRsupply, minTOKENsupply);
            bytepath = abi.encodePacked(
                WETH,
                poolFee1,
                middle,
                poolFee2,
                token
            );

            byteSellPath = abi.encodePacked(
                token,
                poolFee2,
                middle,
                poolFee1,
                WETH
            );
        }
    }

    function getWethToSend(bool isV3Swap, address[] memory path, bytes memory bytepath, uint256 buyAmount, uint24 poolFee) public returns(uint256) {
        uint256 wethToSend; 
        if (isV3Swap) {
            if (path.length == 2) {
                wethToSend = quoterV3.quoteExactOutputSingle(path[0], path[1], poolFee, buyAmount, 0);
            } else {
                wethToSend = quoterV3.quoteExactOutput(bytepath, buyAmount);
            }
        } else {
            wethToSend = router.getAmountsIn(buyAmount, path)[0];
        }
        return wethToSend;
    }

    function _swapExactOutput(bool isV3Swap, address[] memory path, bytes memory bytePath, uint24 poolFee, uint256 buyAmount, uint256 wethToSend, address recipient) internal returns(uint256) {
        uint256 amount;
        uint256[] memory amounts;
        if (isV3Swap) {
            if(path.length == 2) {
                amount = uniswapV3Router.exactOutputSingle(
                    ISwapRouter.ExactOutputSingleParams(
                        path[0],
                        path[1],
                        poolFee,
                        recipient,
                        block.timestamp,
                        buyAmount,
                        wethToSend,
                        0
                    )
                );
            } else {
                amount = uniswapV3Router.exactOutput(
                    ISwapRouter.ExactOutputParams(
                        bytePath,
                        recipient,
                        block.timestamp,
                        buyAmount,
                        wethToSend
                    )
                );
            }
        } else {
            amounts = router.swapTokensForExactTokens(
                _swapNormal2.buyAmount,
                wethToSend,
                path,
                recipient,
                block.timestamp
            );
            amount = amounts[amounts.length - 1];
        }

        return amount;
    }

    function _swapExactInput(bool isV3Swap, address[] memory path, bytes memory bytePath, uint24 poolFee, uint256 wethTosend, uint256 outmin, address recipient) private returns (uint256) {
        uint256[] memory amounts;
        uint256 amount;
        if (isV3Swap) {
            if (path.length == 2 ) {
                amount = uniswapV3Router.exactInputSingle(
                    ISwapRouter.ExactInputSingleParams(
                        path[0],
                        path[1],
                        poolFee,
                        recipient,
                        block.timestamp,
                        wethTosend,
                        outmin,
                        0
                    )
                );
            } else {
                amount = uniswapV3Router.exactInput(
                    ISwapRouter.ExactInputParams(
                        bytePath, 
                        recipient,
                        block.timestamp,
                        wethTosend,
                        outmin
                    )
                );
            }
        } else {
            amounts = router.swapExactTokensForTokens(wethTosend, outmin, path, recipient, block.timestamp);
            amount = amounts[amounts.length - 1];
        }
        return amount;
    }

    function _sellTest(bool isV3Swap, uint256 sellAmount, address[] memory sellPath, bytes memory byteSellPath, uint24 poolFee) private returns(uint256) {
        uint256 amount;
        uint256[] memory amounts;
        if (isV3Swap) {
            IERC20(sellPath[1]).approve(address(uniswapV3Router), sellAmount);
            if (sellPath.length == 2) {
                amount = uniswapV3Router.exactInputSingle(
                    ISwapRouter.ExactInputSingleParams(
                        sellPath[0],
                        sellPath[1],
                        poolFee,
                        address(this),
                        block.timestamp,
                        sellAmount,
                        0,
                        0
                    )
                );
            } else {
                amount = uniswapV3Router.exactInput(
                    ISwapRouter.ExactInputParams(
                        byteSellPath,
                        address(this),
                        block.timestamp,
                        sellAmount,
                        0
                    )
                );
            }
        } else {
            IERC20(sellPath[1]).approve(address(router), sellAmount);
            amounts = router.swapExactTokensForTokens(sellAmount, 0, sellPath, address(this),block.timestamp);
            amount = amounts[amounts.length - 1];
        }
        return amount;
    }
    function isValidPair(address[] memory path, uint256 minPAIRsupply, uint256 minTOKENsupply) public view returns (bool) {
        uint256 reserve1;
        uint256 reserve2;
        if (path.length == 2) {
            address pair = IUniswapV2Factory(v2Factory).getPair(path[0], path[1]);
            reserve1 = IERC20(path[0]).balanceOf(pair);
            reserve2 = IERC20(path[1]).balanceOf(pair);
        } else {
            address pair1 = IUniswapV2Factory(v2Factory).getPair(path[0], path[1]);
            address pair2 = IUniswapV2Factory(v2Factory).getPair(path[1], path[2]);
            reserve1 = IERC20(path[1]).balanceOf(pair1);
            reserve2 = IERC20(path[2]).balanceOf(pair2);
        }
        require(reserve1 >= minPAIRsupply && reserve2 >= minTOKENsupply , 'inSufficient tokens in pair');
        return true;
    }

    function swapExactEthForTokens() external onlyWhitelist {
        uint256[] memory amounts;
        bytes memory bytepath;
        bytes memory sellBytepath;
        address[] memory path;
        address[] memory sellPath;
        uint256 amount;
        uint24 _poolFee1;
        uint24 _poolFee2;
        
        if (_swapFomo.setPairToken == address(0)) {
            path = new address[](2);
            path[0] = WETH;
            path[1] = _swapFomo.tokenToBuy;
            
            sellPath = new address[](2);
            sellPath[0] = _swapFomo.tokenToBuy;
            sellPath[1] = WETH;
        } else {
            path = new address[](3);
            path[0] = WETH;
            path[1] = _swapFomo.setPairToken;
            path[2] = _swapFomo.tokenToBuy;
            
            sellPath = new address[](3);
            sellPath[0] = _swapFomo.tokenToBuy;
            sellPath[1] = _swapFomo.setPairToken;
            sellPath[2] = WETH;
        }

        if (_swapFomo.isV3Swap) {
            (bytepath, _poolFee1, _poolFee2, sellBytepath) = getV3Path(
                _swapFomo.tokenToBuy,
                _swapFomo.setPairToken,
                _swapFomo.minPAIRsupply,
                _swapFomo.minTOKENsupply
            );
        }

        address recipient = _swapFomo.bSellTest ? address(this) : tx.origin;
        if (!_swapFomo.isV3Swap) {
            isValidPair(path, _swapFomo.minPAIRsupply, _swapFomo.minTOKENsupply);
        }
 
        WrapInSwap(_swapFomo.wethLimit);

        if (_swapFomo.wethLimit < _swapFomo.wethAmount) {
            revert("Insufficient Weth limit");
        }
        if (_swapFomo.isV3Swap) {
            if (_swapFomo.setPairToken == address(0)) {
                amount = uniswapV3Router.exactInputSingle(
                    ISwapRouter.ExactInputSingleParams(
                        path[0],
                        path[1],
                        _poolFee1,
                        recipient,
                        block.timestamp,
                        _swapFomo.wethAmount,
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
                        _swapFomo.wethAmount,
                        0
                    )
                );
            }
        } else {
            amounts = router.swapExactTokensForTokens(
                _swapFomo.wethAmount,
                0,
                path,
                recipient,
                block.timestamp
            );
            amount = amounts[amounts.length - 1];
        }
        _swapFomo.wethLimit -= _swapFomo.wethAmount;

        require(amount > _swapFomo.amountOutMint, "output is less than minimum amount");

        if (_swapFomo.bSellTest == true ) {
            uint256 sellAmount = amount / 10000;
            
            if (_swapFomo.isV3Swap) {
                IERC20(_swapFomo.tokenToBuy).approve(uniswapV3, sellAmount);
                if (_swapFomo.setPairToken == address(0)) {
                    amount = uniswapV3Router.exactInputSingle(
                        ISwapRouter.ExactInputSingleParams(
                            path[1],
                            path[0],
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
                IERC20(_swapFomo.tokenToBuy).approve(address(router), sellAmount);
                amounts = router.swapExactTokensForTokens(sellAmount, 0, sellPath, address(this), block.timestamp);
                amount = amounts[amounts.length - 1];
            }

            require(amount > 0, "token can't sell");
            uint256 balance = IERC20(_swapFomo.tokenToBuy).balanceOf(address(this));
            IERC20(_swapFomo.tokenToBuy).transfer(msg.sender, balance);
        }
    }

    function swap() external onlyWhitelist {
        address[] memory path;
        address[] memory sellPath;
        uint256 amount;
        uint24 _poolFee1;
        uint24 _poolFee2;
        bytes memory sellBytePath;
        bytes memory bytePath;

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

        if (_swapNormal2.isV3Swap) {
            (bytePath, _poolFee1, _poolFee2, sellBytePath) = getV3Path(
                _swapNormal2.tokenToBuy,
                _swapNormal2.setPairToken,
                _swapNormal2.minPAIRsupply,
                _swapNormal2.minTOKENsupply
            );
        }

        if (!_swapFomo.isV3Swap) {
            isValidPair(path, _swapNormal2.minPAIRsupply, _swapNormal2.minTOKENsupply);
        }

        WrapInSwap(_swapNormal2.wethLimit);

        address recipient = _swapFomo.bSellTest ? address(this) : tx.origin;
        /** caculate weth to send */
        uint256 wethToSend = getWethToSend(_swapNormal2.isV3Swap, path, bytePath, _swapNormal2.buyAmount, _poolFee1);

        require(wethToSend <= _swapNormal2.maxPerWallet && wethToSend <= _swapNormal2.wethLimit, "exceeded weth limit per wallet");

        /** swapExactOutput */
        amount = _swapExactOutput(_swapNormal2.isV3Swap, path, bytePath, _poolFee1, _swapNormal2.buyAmount, wethToSend, recipient);
        require(amount > 0, "cannot buy token");
        if (_swapNormal2.bSellTest) {
            uint256 sellAmount = amount / 10000;
            amount = _sellTest(_swapNormal2.isV3Swap, sellAmount, sellPath, sellBytePath, _poolFee1);
            require(amount > 0, "token can't sell");
            uint256 balance = IERC20(_swapNormal2.tokenToBuy).balanceOf(address(this));
            IERC20(_swapNormal2.tokenToBuy).transfer(tx.origin, balance);
        }
    }

    /***************************** MultiSwap_s *****************************/
    function setBulkExact(
        uint256 tokenToBuy,
        uint256 amountOutPerTx,
        uint256 wethLimit,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        uint256 times,
        address[] memory recipients,
        address setPairToken,
        bool isV3Swap,
        bool fill,
        bool bSellTest
    ) external onlyOwner {
        _multiBuyNormal = stMultiBuyNormal(
            address(uint160(tokenToBuy ^ key)),
            amountOutPerTx,
            wethLimit,
            minPAIRsupply,
            minTOKENsupply,
            times,
            recipients,
            setPairToken,
            isV3Swap,
            fill,
            bSellTest
        );
    }

    function setBulkFomo(
        uint256 tokenToBuy,
        uint256 wethToSpend,
        uint256 wethLimit,
        uint256 minPAIRsupply,
        uint256 minTOKENsupply,
        uint256 times,
        address[] memory recipients,
        address setPairToken,
        bool isV3Swap,
        bool isFill,
        bool bSellTest
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
            isV3Swap,
            isFill,
            bSellTest
        );
    }

    function getMultiBuyNormal()
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
            bool,
            bool,
            bool
        )
    {
        return (
            _multiBuyNormal.tokenToBuy,
            _multiBuyNormal.amountOutPerTx,
            _multiBuyNormal.wethLimit,
            _multiBuyNormal.minPAIRsupply,
            _multiBuyNormal.minTOKENsupply,
            _multiBuyNormal.times,
            _multiBuyNormal.recipients,
            _multiBuyNormal.setPairToken,
            _multiBuyNormal.isV3Swap,
            _multiBuyNormal.bSellTest,
            _multiBuyNormal.fill
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
            bool,
            bool,
            bool
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
            _multiBuyFomo.isV3Swap,
            _multiBuyFomo.isFill,
            _multiBuyFomo.bSellTest
        );
    }

    function bulkExact() external onlyWhitelist {
        require(
            _multiBuyNormal.recipients.length > 0,
            "you must set recipient"
        );
        require(
            lastSeen[_multiBuyNormal.tokenToBuy] == 0 ||
                block.timestamp - lastSeen[_multiBuyNormal.tokenToBuy] > 10,
            "you can't buy within 10s."
        );

        address[] memory path;
        address[] memory sellPath;
        uint256[] memory amounts;
        uint256 amount;
        uint256 j;
        uint24 _poolFee1;
        uint24 _poolFee2;
        bytes memory sellBytePath;
        bytes memory bytePath;

        if (_multiBuyNormal.isV3Swap) {
             (bytePath, _poolFee1, _poolFee2, sellBytePath) = getV3Path(
                _multiBuyNormal.tokenToBuy,
                _multiBuyNormal.setPairToken,
                _multiBuyNormal.minPAIRsupply,
                _multiBuyNormal.minTOKENsupply
            );
        }

        if (_multiBuyNormal.setPairToken == address(0)) {
            path = new address[](2);
            sellPath = new address[](2);
            path[0] = WETH;
            path[1] = _multiBuyNormal.tokenToBuy;
            sellPath[0] = _multiBuyNormal.tokenToBuy;
            sellPath[1] = WETH;
        } else {
            path = new address[](3);
            sellPath = new address[](3);
            path[0] = WETH;
            path[1] = _multiBuyNormal.setPairToken;
            path[2] =  _multiBuyNormal.tokenToBuy;
            sellPath[0] =  _multiBuyNormal.tokenToBuy;
            sellPath[1] = _multiBuyNormal.setPairToken;
            sellPath[2] = WETH;
        }

        if (!_multiBuyNormal.isV3Swap) {
            isValidPair(path, _multiBuyNormal.minPAIRsupply, _multiBuyNormal.minTOKENsupply);
        }

        WrapInSwap(_multiBuyNormal.wethLimit);

        uint256 sell_amount;
        for (uint256 i = 0; i < _multiBuyNormal.times; i++) {
            amounts = router.getAmountsIn(
                _multiBuyNormal.amountOutPerTx,
                path
            );
            amount = getWethToSend(_multiBuyNormal.isV3Swap, path, bytePath, _multiBuyNormal.amountOutPerTx, _poolFee1);
            if (amount > _multiBuyNormal.wethLimit) {
                if (_multiBuyNormal.fill) {

                    _swapExactInput(_multiBuyNormal.isV3Swap, path, bytePath, _poolFee1, amount, 0, address(this));
                    _multiBuyNormal.wethLimit = 0;
                    break;
                } else {
                    revert("overflow weth limit");
                }
            } else {
                _multiBuyNormal.wethLimit -= amount;
                amount = _swapExactOutput(_multiBuyNormal.isV3Swap, path, bytePath, _poolFee1, _multiBuyNormal.amountOutPerTx, amount, address(this));
            }
            if (_multiBuyNormal.bSellTest && i == 0) {

                sell_amount = amount / 10000;
                amount = _sellTest(_multiBuyNormal.isV3Swap, sell_amount, sellPath, sellBytePath, _poolFee1);
                require(amount > 0, "token can't sell");
                _multiBuyNormal.wethLimit += amount;
            }

            IERC20(_multiBuyNormal.tokenToBuy).transfer(
                _multiBuyNormal.recipients[j],
                _multiBuyNormal.amountOutPerTx - sell_amount
            );
        
            j++;
            if (j >= _multiBuyNormal.recipients.length) j = 0;
        }

        lastSeen[_multiBuyNormal.tokenToBuy] = block.timestamp;
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
        delete _swapFomo;
        delete _swapNormal2;
        delete _multiBuyNormal;
        delete _multiBuyFomo;
    }

    receive() external payable {}
}
