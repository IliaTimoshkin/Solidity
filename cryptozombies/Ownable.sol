pragma solidity >=0.5.0 <0.6.0;

/**
* @title Ownable
* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor() internal {                              //Constructor is someway 'contract' which runs only once - when contract deployed
    _owner = msg.sender;                                //Set _owner to msg.sender - so person who deploy it is the owner
    emit OwnershipTransferred(address(0), _owner);
  }

  function owner() public view returns(address) {       //Function so that we can see who is the owner of contract
    return _owner;
  }

  modifier onlyOwner() {                                 //Modifier is a 'half-function' used to check requirement without giving access to the functions of contract
    require(isOwner());                                  //Check if user is owner
    _;
  }

  function isOwner() public view returns(bool) {        //Returns True if user is owner
    return msg.sender == _owner;
  }

  /**
  * @dev Allows the current owner to relinquish control of the contract.
  * @notice Renouncing to ownership will leave the contract without an owner.
  * It will not be possible to call the functions with the `onlyOwner`
  * modifier anymore.
  */
  function renounceOwnership() public onlyOwner {       //Reset ownership
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
  * @dev Transfers control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
  */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
    
  /**
  * @dev Allows the current owner to transfer control of the contract to a newOwner.
  * @param newOwner The address to transfer ownership to.
  */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }


  }
}
