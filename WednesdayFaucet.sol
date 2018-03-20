pragma solidity ^0.4.18;

import "./ownable.sol";
import "./destructible.sol";
import "./tokenInterfaces.sol";

/**
 * @title WednesdayCoinFaucet
 * @dev click once every 10 ins for 100 WED
 */
contract WednesdayFaucet is Ownable, Destructible {

    // WednesdayCoin contract being held
    WednesdayCoin public wednesdayCoin;

    // amount
    uint256 public amount;

    mapping(address => uint) public startTime;

    function WednesdayFaucet() {
        //for testing 0xedfc38fed24f14aca994c47af95a14a46fbbaa16
        wednesdayCoin = WednesdayCoin(0x7848ae8f19671dc05966dafbefbbbb0308bdfabd);
        amount = 100000000000000000000;
    }

    function click() public {
        //require Wednesday(3)
        uint8 dayOfWeek = uint8((now / 86400 + 4) % 7);
        require(dayOfWeek == 3);

        require(hasElapsed());

        require(wednesdayCoin.balanceOf(this) >= amount);

        wednesdayCoin.transfer(msg.sender, amount);
        startTime[msg.sender] = now;
    }

    function hasElapsed() public returns (bool hasElapsed) {
        if (now >= startTime[msg.sender] + 10 minutes) {
            // 10 minutes has elapsed from startTime[msg.sender]
            return true;
        }
        return false;
    }

    function setAmount(uint256 _amount) public onlyOwner {
        amount = _amount;
    }

    // Used for transferring any accidentally sent ERC20 Token by the owner only
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }

    // Used for transferring any accidentally sent Ether by the owner only
    function transferEther(address dest, uint amount) public onlyOwner {
        dest.transfer(amount);
    }
}