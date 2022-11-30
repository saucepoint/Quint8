// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { PRBTest } from "@prb/test/PRBTest.sol";

import { Quint8Mock } from "../src/example/Quint8Mock.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract Quint8Test is PRBTest {
    Quint8Mock q1;
    uint8 testNumber;

    function setUp() public {
        q1 = new Quint8Mock();
    }

    /// @dev Run Forge with `-vvvv` to see console logs.
    function testEnqueue() public {
        assertEq(true, true);
        q1.enqueue(5);
        q1.enqueue(4);
        q1.enqueue(3);
        q1.enqueue(2);
        q1.enqueue(1);
        assertEq(q1.size(), 5);
    }

    function testDequeue() public {
        q1.enqueue(5);
        q1.enqueue(4);
        q1.enqueue(3);
        q1.enqueue(2);
        q1.enqueue(1);


        assertEq(q1.dequeue(), 5);
        assertEq(q1.dequeue(), 4);
        assertEq(q1.dequeue(), 3);
        assertEq(q1.dequeue(), 2);
        assertEq(q1.dequeue(), 1); //at this point the queue is empty
    }

    function testFive() public {
        q1.yoUhhHmm();
        assertEq(q1.size(), 0);
    }
}
