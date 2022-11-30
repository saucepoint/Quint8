// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

/// max capacity 1024 uint8s
struct Queue {
    bytes32[4] pages;
    uint256 count;
}

library Quint8 {
    uint256 constant private MAX_CAPACITY = 1024;

    function enqueue(Queue memory _queue, uint8 num) internal pure returns (Queue memory) {
        uint256 count = _queue.count;
        require(count < MAX_CAPACITY, "Queue is full");
        
        bytes32 page = _queue.pages[count / 32];
        uint256 index = count % 32;

        bytes32 insertion;
        assembly {
            // shift the number to the left to pack it into the page
            // ```
            // page = 0x11_22_33_44_00_00_..._00
            // num = 0x55
            // insertion = 0x55_00_..._00 // shift to the left, leaving leading 0's equal to page's current length
            // page = 0x11_22_33_44_55_00_..._00 // insert via OR
            // ```

            // num << ((31 - index) * 8)
            insertion := shl(mul(sub(0x1F, index), 8), num)
            page := or(page, insertion)
        }
        _queue.pages[count / 32] = page;

        unchecked { ++_queue.count; }
        return _queue;
    }

    function dequeue(Queue memory _queue) internal pure returns (Queue memory, uint8) {
        bytes32 head = _queue.pages[0];
        uint8 result;
        assembly {            
            result := shr(248, head)
            head := shl(8, head)
        }
        _queue.pages[0] = head;
        unchecked {
            --_queue.count;
        }
        return (_queue, result);
    }
}