pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {                               //Create interface contract to interract with other contract with cryptokitties :) 
  function getKitty(uint256 _id) external view returns (    // Functions in Solidity can return more than one argument
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {               //Create another contract subordinate to ZombieFactory contract

  KittyInterface kittyContract;        //Define for Kittycontract where cryptokitties stores in the blockchain
  
  function setKittyContractAddress(address _address) external onlyOwner {       //Function to set address for cryptockitties contract. Note that we can change it in case.
    kittyContract = KittyInterface(_address);                                   //onlyOwner modifier from Ownable contract
  }
  
  modifier ownerOf(uint _zombieId) {                                            //Modifier to check if user own particular zombie
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }
  
  fuction _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }
  
  function _isReady(Zobie storage _zombie) internal view returns (bool) {
    return (_zombie.readyTime <= now);
  }
  
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal ownerOF(_zombieId) {   //_species related to animal zombie ate, this case it is "kitty". Change to internal so user could not feed with smth else except kitties
    Zombie storage myZombie = zombies[_zombieId];       //Create new variable myZombie stored as Zombie struct and set it to Zombie in zombies array with _zombieId
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;               //Bring targetDna to 16 digits length
    uint newDna = (myZombie.dna + _targetDna) / 2;      //Calculate newDna as average between target and zombie DNAs
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){       //Check if _species argument of function equal to "kitty"
      newDna = newDna - newDna % 100 + 99;                                                    //If so then we change last 2 digits of calculated newDNA to 99
    }                                                                                         //Explanation: Assume newDna is 334455. Then newDna % 100 is 55, so newDna - newDna % 100 is 334400. Finally add 99 to get 334499
    _createZombie("NoName", newDna);                    //Create new zombie with new DNA. Currently _createZombie is unavailable cuz it is privite insize zombieFactory contract. Need to change it.
    _triggerCooldown(myZombie);                         //Reset cooldown if zombie is created
  }
  
    function feedOnKitty(uint _zombieId, uint _kittyId) public {   //Create fuction for feeding on kitties
    uint kittyDna;                                                 //Declare new uint variable kittyDna
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);        //Set kittyDna to 10th argument function getKitty return (genes=DNA)
    feedAndMultiply(_zombieId, kittyDna);                          //Creating new zombie after feeding kitty
  }
}
