// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import {Quint8, Queue} from "../Quint8.sol";


/// @author @saucepoint
contract Quint8Mock {
    using Quint8 for Queue;

    Queue private queue;

    /// @notice function to insert data inside the queue
    /// @param _data The data that gets inserted
    function enqueue(uint8 _data) external {
        Queue memory _q = queue.enqueue(_data);
        queue = _q;
    }

    /// @notice function to get data from the queue
    /// @return data The data that gets dequeued
    function dequeue() external returns (uint8) {
        (Queue memory _q, uint8 data) = queue.dequeue();
        queue = _q;
        return data;
    }

    function yoUhhHmm() external pure {
        // Strictly in-memory queue example
        Queue memory inMemoryQueue;
        inMemoryQueue = inMemoryQueue.enqueue(1);
        inMemoryQueue = inMemoryQueue.enqueue(2);
        inMemoryQueue = inMemoryQueue.enqueue(3);
        inMemoryQueue = inMemoryQueue.enqueue(4);
        inMemoryQueue = inMemoryQueue.enqueue(5);
        (inMemoryQueue,) = inMemoryQueue.dequeue();
        (inMemoryQueue,) = inMemoryQueue.dequeue();
        (inMemoryQueue,) = inMemoryQueue.dequeue();
        (inMemoryQueue,) = inMemoryQueue.dequeue();
        (inMemoryQueue,) = inMemoryQueue.dequeue();
    }

    function size() external view returns (uint256) {
        return queue.count;
    }
}
