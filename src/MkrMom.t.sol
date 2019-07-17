// Copyright (C) 2019 Maker Ecosystem Growth Holdings, INC.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

  function rely(address usr) public {
    mom.rely(usr);
  }

  function deny(address usr) public {
    mom.deny(usr);
  }

  function mint(address usr, uint wad) public {
    mom.mint(usr, wad);
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
    fkr.setOwner(address(mom));
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

  function testRely() public {
    assertEq(mom.wards(address(caller)), 0);
    mom.rely(address(caller));
    assertEq(mom.wards(address(caller)), 1);
  }

  function testFailRely() public {
    // caller is not mom's owner, so can't call rely
    caller.rely(address(caller));
  }

  function testDeny() public {
    mom.rely(address(caller));
    mom.deny(address(caller));
    assertEq(mom.wards(address(caller)), 0);
  }

  function testFailDeny() public {
    // caller is not mom's owner, so can't call deny
    caller.deny(address(caller));
  }

  function testMintOwner() public {
    mom.mint(address(this), 84);
    assertEq(fkr.balanceOf(address(this)), 84);
  }

  function testMintRely() public {
    mom.rely(address(caller));
    caller.mint(address(caller), 42);
    assertEq(fkr.balanceOf(address(caller)), 42);
  }

  function testFailMint() public {
    caller.mint(address(caller), 42);
  }

  function testBurn() public {
    mom.mint(address(this), 50);
    assertEq(fkr.balanceOf(address(this)), 50);
    fkr.approve(address(mom));
    mom.burn(address(this), 20);
    assertEq(fkr.balanceOf(address(this)), 30);
    assertEq(fkr.totalSupply(), 30);
  }
}
