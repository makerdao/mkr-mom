pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MkrMom.sol";

contract MkrMomTest is DSTest {
    DSToken fkr;
    MkrMom mom;

    function setUp() public {
        fkr = new DSToken("FKR");
        mom = new MkrMom(fkr);
    }

    function verifyConstruction() public {
      assertTrue(mom.owner() == address(this));
      assertTrue(mom.mkr() == fkr);
    }
}
