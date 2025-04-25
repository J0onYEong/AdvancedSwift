//
//  BSTTests.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

import Testing

@testable import AdvancedSwift

struct BSTIteratorTests {
    
    @Test("좌측 중위 순회 이터레이터 순회 테스트")
    func checkInOrderLeftIterator() {
        // Given
        let tree = BinarySearchTree<Int>()
        
        
        // When
        // - 역순으로 삽입
        let insertingList = (0..<1000).reversed()
        for index in insertingList {
            tree.insert(index)
        }
        
        
        // Then
        var list: [Int] = []
        for element in tree.setIterationType(.inOrderLeft) {
            list.append(element.value)
        }
        #expect(list == insertingList.reversed())
    }
    
    @Test("우측 중위 순회 이터레이터 순회 테스트")
    func checkInOrderRightIterator() {
        // Given
        let tree = BinarySearchTree<Int>()
        
        
        // When
        let insertingList = (0..<1000)
        for index in insertingList {
            tree.insert(index)
        }
        
        
        // Then
        var list: [Int] = []
        for element in tree.setIterationType(.inOrderRight) {
            list.append(element.value)
        }
        #expect(list == insertingList.reversed())
    }
}
