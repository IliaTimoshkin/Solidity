pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {                      //Set inheritance to ZombieFeeding contract

  uint levelUpFee = 0.001 ether;                              //Set lvlup fee in ether


  modifier aboveLevel(uint _level, uint _zombieId) {          //Create modifier to check Zombie's lvl
    require(zombies[_zombieId].level >= _level);
    _;
  }
  
  function withdraw() external onlyOwner {                    //Function to widtdraw money
    address payable _owner = address(uint160(owner()));       //Cant get it yet
    _owner.transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {      //Function to set lvlupfee for owner of the contract
    levelUpFee = _fee;
  }
  
   function levelUp(uint _zombieId) external payable {        //Function to lvlup Zombie with payment
    require(msg.value == levelUpFee);                         //check if sended value is equal to lvlupfee
    zombies[_zombieId].level++;                               //ifso then lvlup Zombie
  }
  
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2,_zombieId) ownerOf(_zombieId) {   //Function to rename Zombie if it is above lvl 2      
    zombies[_zombieId].name = _newName;
  }
  
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20,_zombieId) ownerOf(_zombieId) {   //Function to set custom DNA to Zombie if it is above lvl 20       
    zombies[_zombieId].dna = _newDna;
}

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);   //Create new list with length of total zombie owned by user
    uint counter = 0;                                              //Counter for resulted array
    for (uint i = 0; i < zombies.length; i++) {                    //Go through zombies array
      if (zombieToOwner[i] == _owner) {                            //And check if any zombie owned by user
        result[counter] = i;                                       //If so - we put zombie ID to new array 'result'
        counter++;                                                 //Move forwards new array counter
      }
  }
