pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MkrMom.sol";

contract MkrMomTest is DSTest {
    MkrMom mom;

    function setUp() public {
        mom = new MkrMom();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
