pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MkrMom.sol";

contract MkrMomCaller {
  MkrMom mom;

  constructor(MkrMom mom_) public {
    mom = mom_;
  }

  function setOwner(address newOwner) public {
    mom.setOwner(newOwner);
  }
}

contract MkrMomTest is DSTest {
  DSToken fkr;
  MkrMom mom;
  MkrMomCaller caller;

  function setUp() public {
    fkr = new DSToken("FKR");
    mom = new MkrMom(fkr);
    caller = new MkrMomCaller(mom);
  }

  function testVerifyConstruction() public {
    assertTrue(mom.owner() == address(this));
    assertTrue(mom.mkr() == fkr);
  }

  function testSetOwner() public {
    mom.setOwner(address(caller));      
    assertTrue(mom.owner() == address(caller));
    caller.setOwner(address(this));
    assertTrue(mom.owner() == address(this));
  }

  function testFailSetOwner() public {
    assertTrue(mom.owner() != address(caller));
    caller.setOwner(address(caller));
  }
}
