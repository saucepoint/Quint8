// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;


struct Queue {
    bytes32[4] pages;
    uint128 count;
    uint128 head;
}


library Quint8 {
    // 4 pages holding 32x uint8 each, 1024x uint8 total
    uint256 constant private MAX_CAPACITY = 1024;
    uint256 constant private PAGE_SIZE = 32;  // 32x uint8 per page

    function enqueue(Queue memory _queue, uint8 num) internal pure returns (Queue memory) {
        uint256 count = _queue.count;
        require(count < MAX_CAPACITY, "Queue is full");

        uint256 pageIndex;
        unchecked {
            pageIndex = count / PAGE_SIZE;
        }
        
        bytes32 page = _queue.pages[pageIndex];

        bytes32 insertion;
        assembly {
            // shift the number to the left to pack it into the page
            // ```
            // page = 0x11_22_33_44_00_00_..._00
            // num = 0x55
            // insertion = 0x55_00_..._00 // shift to the left, leaving leading 0's equal to page's current length
            // page = 0x11_22_33_44_55_00_..._00 // insert via OR
            // ```

            // num << ((31 - index) * 8) // (inserting at index=0 means we should left shift by 248 bits)
            let index := mod(count, PAGE_SIZE)
            insertion := shl(mul(sub(0x1F, index), 8), num)
            
            // pack the number `insertion` into the page
            page := or(page, insertion)
        }
        _queue.pages[pageIndex] = page;

        unchecked { ++_queue.count; }
        return _queue;
    }

    function dequeue(Queue memory _queue) internal pure returns (Queue memory, uint8) {
        uint256 head = _queue.head;
        uint256 pageIndex;
        unchecked {
            pageIndex = _queue.head / 32;
        }

        bytes32 page = _queue.pages[pageIndex];
        uint8 result;
        
        assembly {
            // index of the head pointer, within the page
            let index := mod(head, 32)

            // shift the number to the right to unpack it from the page
            result := shr(mul(sub(0x1F, index), 8), page)

            // clear the number from the page
            page := and(page, not(shl(mul(sub(0x1F, index), 8), 0xFF)))
        }
        _queue.pages[pageIndex] = page;
        unchecked {
            ++_queue.head;
            --_queue.count;
        }
        return (_queue, result);
    }
}