pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;                                //DNA only takes 16 digits
    uint dnaModulus = 10 ** dnaDigits;                  // Define dnaModulus as 10^16 so we could get only 16 digits from any number in future
    uint32 cooldownTime = 1 days;                       //Cooldown for eating

    struct Zombie {                                     //Declare that Zombie consists of its name and DNA
        string name;
        uint dna;
        uint32 level;                                   //Store similar size uint nearby so Solidity could pack it together and lower gas fees
        uint32 readyTime;
    }

    Zombie[] public zombies;                             //Declare dynamic public array 'zombies' consist of created Zombies

    mapping (uint => address) public zombieToOwner;      //Attach Zombie ID to Hash_address
    mapping (address => uint) ownerZombieCount;          //Attach Hash to ZombieCount

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1; // Current zombie ID set as length of zombies array minus 1
        zombieToOwner[id] = msg.sender;                  //Attach calculated ID to user
        ownerZombieCount[msg.sender]++;                  //increase user zombie count by 1
        emit NewZombie(id, _name, _dna);                 //emit information from blockchain to app
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));  // Create random uint from string (then use _name for it)
        return rand % dnaModulus;                             // To be sure that future randDna from _name will be only 16 digits
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);     //createRandomZombie only works when user do not have Zombies yet
        uint randDna = _generateRandomDna(_name);       //generate randomDNA from string _name
        _createZombie(_name, randDna);                  //create zombie with selected name and random DNA
    }

}


