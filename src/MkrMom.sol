pragma solidity ^0.5.10;

import "ds-note/note.sol";
import "ds-token/token.sol";

contract MkrMom {
  address owner;
  modifier onlyOwner { require(msg.sender == owner); _;}

  mapping (address => uint) public wards;
  function rely(address usr) public note onlyOwner { wards[usr] = 1; }
  function deny(address usr) public note onlyOwner { wards[usr] = 0; }
  modifier auth { require(owner == msg.sender || wards[msg.sender] == 1); _; }

  DSToken public mkr;

  constructor(DSToken mkr_) public {
    owner = msg.sender;
    mkr = mkr_;
  }

  function setOwner(address owner_) public note onlyOwner {
    owner = owner_;
  }

  function mint(address usr, uint wad) public auth {
    mkr.mint(usr, wad);
  }

  function burn(address usr, uint wad) public auth {
    mkr.burn(usr, wad);
  }
}
