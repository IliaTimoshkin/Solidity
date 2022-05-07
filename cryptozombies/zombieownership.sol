pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {                                                      //Contract to set ownershit of Zombies

  mapping (uint => address) zombieApprovals;                                                            //Mapping for approved addresses with particular zombieId=tokenId

  function balanceOf(address _owner) external view returns (uint256) {                                  //Function returns zombie count for user selected
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {                                  //Function returns owner of selected zombie
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {                            //Function supposed to transfer zombies from one user (_from) to another (_to)
    ownerZombieCount[_to]++;                                                                            //Plus zombie count for _to
    ownerZombieCount[_from]--;                                                                          //Minus zombie count for _from
    zombieToOwner[_tokenId] = _to;                                                                      //Set owner of transfered zombie to _to
    emit Transfer(_from, _to, _tokenId);                                                                //emit ERC721 event Transfer
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {                //Function to charge money for transfer
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);         //Check if function caller is zombie owner or approved user
    _transfer(_from, _to, _tokenId);                                                                    //Transfer zombie
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {        //Function to approve user before transfer
    zombieApprovals[_tokenId] = _approved;                                                              //Put user in mapping
    emit Approval(msg.sender, _approved, _tokenId);                                                     //Emit ERC721 event
  }
}
