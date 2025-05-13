//
//  HeapTests.swift
//  AdvancedSwift
//
//  Created by choijunios on 5/13/25.
//

import Testing

import AdvancedSwift

@Suite("Heap자료구조 테스트")
struct HeapTests {
    @Test("최소힙이 유도한대로 요소를 반환하는지 확인합니다.", arguments: [
        [5, 4, 3, 2, 1],
        [1, 2, 3, 4, 5,],
        [-1, -2, -3, -4, -5],
        [-2, -1, 0, 1, 2],
        [1],
    ])
    func checkMinHeap(elements: [Int]) {
        // Given
        var minHeap = Heap<Int>(heapType: .min)
        elements.forEach { element in
            minHeap.insert(element)
        }
        
        
        // When
        var tops: [Int] = []
        while let top = minHeap.popTop() {
            tops.append(top)
        }
        
        
        // Then
        #expect(tops.count == elements.count)
        #expect(elements.sorted(by: <) == tops)
    }
    
    
    @Test("최대힙이 유도한대로 요소를 반환하는지 확인합니다.", arguments: [
        [5, 4, 3, 2, 1],
        [1, 2, 3, 4, 5,],
        [-1, -2, -3, -4, -5],
        [-2, -1, 0, 1, 2],
        [1],
    ])
    func checkMaxHeap(elements: [Int]) {
        // Given
        var maxHeap = Heap<Int>(heapType: .max)
        elements.forEach { element in
            maxHeap.insert(element)
        }
        
        
        // When
        var tops: [Int] = []
        while let top = maxHeap.popTop() {
            tops.append(top)
        }
        
        
        // Then
        #expect(tops.count == elements.count)
        #expect(elements.sorted(by: >) == tops)
    }
    
    
    struct SomeType: Equatable {
        let value: Int
    }
    @Test("Comparable이 아닌 타입도 의도한대로 동작하는지 확인합니다.", arguments: [
        [SomeType(value: 5), SomeType(value: 4), SomeType(value: 3), SomeType(value: 2), SomeType(value: 1)]
    ])
    func checkNotComparable(elements: [SomeType]) {
        // Give
        let compare: ((SomeType, SomeType) -> Bool) = { lhs, rhs in
            lhs.value < rhs.value
        }
        var heap = Heap<SomeType>(compare: compare)
        elements.forEach { element in
            heap.insert(element)
        }
        
        
        // When
        var tops: [SomeType] = []
        while let top = heap.popTop() {
            tops.append(top)
        }
        
        
        // Then
        #expect(tops.count == elements.count)
        #expect(elements.sorted(by: compare) == tops)
    }
}
