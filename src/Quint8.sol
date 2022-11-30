// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;


struct Queue {
    uint128 count;
    uint128 head;
    bytes32[4] pages;
}

library Quint8 {
    // 4 pages holding 32x uint8 each, 128x uint8 total
    uint128 constant private MAX_CAPACITY = 128;
    uint128 constant private PAGE_SIZE = 32;  // 32x uint8 per page

    function enqueue(Queue memory _queue, uint8 num) internal pure returns (Queue memory) {
        uint256 count = _queue.count;
        require(count < MAX_CAPACITY, "Queue is full");
        
        uint256 head = _queue.head;
        
        // which page to write to (the index of queue.pages)
        uint256 pageIndex;
        unchecked {
            pageIndex = ((head + count) % MAX_CAPACITY) / PAGE_SIZE;
        }
        bytes32 page = _queue.pages[pageIndex];

        assembly {
            // shift the number to the left to pack it into the page
            // ```
            // page = 0x11_22_33_44_00_00_..._00
            // num = 0x55
            // insertion = 0x55_00_..._00 // shift to the left, leaving leading 0's equal to page's current length
            // page = 0x11_22_33_44_55_00_..._00 // insert via OR
            // ```

            // the index to insert *within* a page:
            // (head + count) % MAX_CAPACITY % PAGE_SIZE
            let indexInPage := mod(mod(add(head, count), MAX_CAPACITY), PAGE_SIZE)
            
            // num << ((31 - index) * 8) // (inserting at index=0 means we should left shift by 248 bits)
            let insertion := shl(mul(sub(31, indexInPage), 8), num)
            
            // pack the number `insertion` into the page
            page := or(page, insertion)
        }
        
        _queue.pages[pageIndex] = page;

        unchecked { ++_queue.count; }
        return _queue;
    }

    function dequeue(Queue memory _queue) internal pure returns (Queue memory, uint8) {
        require(0 < _queue.count, "Queue is empty");
        
        uint256 head = _queue.head;
        uint256 pageIndex;
        unchecked {
            pageIndex = head / PAGE_SIZE;
        }

        bytes32 page = _queue.pages[pageIndex];
        uint8 result;
        
        assembly {
            // index of the head pointer, within the page
            let index := mod(head, PAGE_SIZE)

            // shift the number to the right to unpack it from the page
            result := shr(mul(sub(0x1F, index), 8), page)

            // clear the number from the page
            page := and(page, not(shl(mul(sub(31, index), 8), 0xFF)))
        }
        
        _queue.pages[pageIndex] = page;
        unchecked {
            _queue.head = (_queue.head + 1) % MAX_CAPACITY;
            --_queue.count;
        }
        return (_queue, result);
    }
}