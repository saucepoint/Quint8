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

    function testCannotDequeueWhenStoreIsEmpty1() public {
        vm.expectRevert();
        q1.dequeue();
    }

    function testCannotDequeueWhenStoreIsEmpty2() public {
        q1.enqueue(5);
        q1.enqueue(4);
        q1.enqueue(3);
        q1.enqueue(2);
        q1.enqueue(1);

        q1.dequeue();
        q1.dequeue();
        q1.dequeue();
        q1.dequeue();
        q1.dequeue(); //at this point the queue is empty

        vm.expectRevert();
        q1.dequeue();
    }

    // ----------------------------------
    // ADDITIONAL TESTS
    // ----------------------------------

    function testFive() public {
        q1.yoUhhHmm();
        assertEq(q1.size(), 0);
    }

    function testFullPageExact() public {
        for (uint8 i = 0; i < 32; i++) {
            q1.enqueue(i);
        }
        assertEq(q1.size(), 32);
        for (uint8 i = 0; i < 32; i++) {
            assertEq(q1.dequeue(), i);
        }
        assertEq(q1.size(), 0);
    }

    function testFullQueueExact() public {
        for (uint8 i = 0; i < 128; i++) {
            q1.enqueue(i);
        }
        assertEq(q1.size(), 128);
        for (uint8 i = 0; i < 128; i++) {
            assertEq(q1.dequeue(), i);
        }
        assertEq(q1.size(), 0);
    }

    function testTwoPageExact() public {
        for (uint8 i = 0; i < 64; i++) {
            q1.enqueue(i);
        }
        assertEq(q1.size(), 64);
        for (uint8 i = 0; i < 64; i++) {
            assertEq(q1.dequeue(), i);
        }
        assertEq(q1.size(), 0);
    }

    function testFifty() public {
        for (uint8 i = 0; i < 50; i++) {
            q1.enqueue(i);
        }
        assertEq(q1.size(), 50);
        for (uint8 i = 0; i < 50; i++) {
            assertEq(q1.dequeue(), i);
        }
        assertEq(q1.size(), 0);
    }

    function testWrapAround() public {
        uint256 loops = 254;
        for (uint8 i = 0; i < loops; i++) {
            q1.enqueue(i);
            if (i % 2 == 0) {
                q1.dequeue();
            }
        }
        uint256 half = loops / 2;
        assertEq(q1.size(), half);
        for (uint8 i = 0; i < half; i++) {
            assertEq(q1.dequeue(), (i + half));
        }
    }
}
