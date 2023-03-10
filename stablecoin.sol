pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/hashgraph/hedera-contracts/blob/master/contracts/contracts-libs/ERC20.sol";

contract Stablecoin is ERC20 {
    address public owner;
    uint256 public price;
    uint256 public deviation;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        address _owner,
        uint256 _price,
        uint256 _deviation
    ) ERC20(name, symbol, decimals) {
        owner = _owner;
        price = _price;
        deviation = _deviation;
    }

    function mint(uint256 amount) external {
        require(msg.sender == owner, "Only oracle can mint new tokens");
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        require(msg.sender == owner, "Only oracle can burn tokens");
        _burn(msg.sender, amount);
    }

    function setPrice(uint256 newPrice) external {
        require(msg.sender == owner, "Only oracle can update the price");
        require(
            newPrice >= price * (100 - deviation) / 100 && 
            newPrice <= price * (100 + deviation) / 100,
            "Price change exceeds the allowed deviation"
        );
        price = newPrice;
    }

    function send(address to, uint256 amount) public returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, to, amount);
        return true;
    }
}
