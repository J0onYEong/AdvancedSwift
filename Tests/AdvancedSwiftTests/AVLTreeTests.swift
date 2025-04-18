//
//  AVLTreeTests.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/11/25.
//

import Testing
@testable import AdvancedSwift


enum AVLTreeError: Error {
    case noMatch
    case nodeIsNotReleased
}

// MARK: Genenral test
struct AVLTreeRandomListTests {
    
    @Test("list size 10,000")
    func testRandom10000List() throws {
        for _ in 0..<10 {
            // Given, 중복되지 않는 약 1만개의 요소를 삽입
            let tree = AVLTree<Int>()
            let orginal_list = Array(Set((0..<10000).map({ _ in Int.random(in: 1..<100000) })))
            var list = orginal_list
            
            list.forEach { number in
                tree.insert(number)
            }
            
            // When, 랜덤 삭제
            var erased: [Int] = []
            for _ in (0..<3) {
                guard let element = list.randomElement() else { continue }
                list.removeAll(where: { $0 == element })
                erased.append(element)
                let checker = tree.remove(element)
                if checker!.isReleased() == false {
                    throw AVLTreeError.nodeIsNotReleased
                }
            }
            
            // Then, 삭제한 리스트와 삭제된 리스트를 합쳤을 때 원본과 같아야 한다.
            list.append(contentsOf: erased)
            list.sort(by: <)
            let sorted_origin = orginal_list.sorted(by: <)
            if list != sorted_origin {
                throw AVLTreeError.noMatch
            }
        }
    }
}


struct AVLTreeMemoryLeakTests {
    @Test("single removal memory leak test")
    func singleRemovalMemoryLeakTest() {
        // Given
        let tree = AVLTree<Int>()
        let orginal_list = Array(Set((0..<10000).map({ _ in Int.random(in: 1..<100000) })))
        var list = orginal_list
        list.forEach(tree.insert(_:))
        
        // When
        for _ in 0..<100 {
            guard let element = list.randomElement() else { continue }
            list.removeAll(where: { $0 == element })
            let leakChecker = tree.remove(element)
            
            // Then
            #expect(leakChecker != nil)
            #expect(leakChecker!.isReleased())
        }
    }
    
    @Test("remove all nodes")
    func removeAllMemoryLeakTest() {
        // Given
        let tree = AVLTree<Int>()
        let list = Array(Set((0..<10000).map({ _ in Int.random(in: 1..<100000) })))
        list.forEach(tree.insert)
        
        // When
        let checkers = tree.clearWithCheckers()
        
        // Then
        #expect(checkers.count == list.count)
        checkers.forEach { checker in
            #expect(checker.isReleased())
        }
    }
}


struct AVLTreeInsertRemoveExceptionTests {
    @Test("Insert duplicate member")
    func insertDuplicateMember() {
        // Given
        let tree = AVLTree<Int>()
        
        // When
        tree.insert(1)
        tree.insert(1)
        tree.insert(1)
        
        // Then, 중복요소는 무시한다.
        #expect(tree.treeHeight == 1)
    }
    
    @Test("Remove invalid memeber")
    func removeInvalidMember() {
        // Given
        let tree = AVLTree<Int>()
        tree.insert(1)
        
        // When
        let leakChecker = tree.remove(2)
        
        // Then, 요소가 없음으로 해당 요소 대한 매모리 누수 감지기가 반환되지 않는다.
        #expect(leakChecker == nil)
        #expect(tree.treeHeight == 1)
    }
}


struct AVLTreeRotationTests {
    
    @Test("LL Rotation test")
    func LLRotation() {
        // Given
        let tree = AVLTree<Int>()
        
        // When, LL상태
        tree.insert(3)
        tree.insert(2)
        tree.insert(1)
        
        // Then
        // - 회전으로 인해 균형이 맞춰짐
        #expect(tree.treeHeight == 2)
    }
    
    @Test("RR Rotation test")
    func RRRotation() {
        // Given
        let tree = AVLTree<Int>()
        
        // When, LL상태
        tree.insert(1)
        tree.insert(2)
        tree.insert(3)
        
        // Then
        // - 회전으로 인해 균형이 맞춰짐
        #expect(tree.treeHeight == 2)
    }
    
    @Test("LR Rotation test")
    func LRRotation() {
        // Given
        let tree = AVLTree<Int>()
        
        // When, LL상태
        tree.insert(3)
        tree.insert(1)
        tree.insert(2)
        
        // Then
        // - 회전으로 인해 균형이 맞춰짐
        #expect(tree.treeHeight == 2)
    }
    
    @Test("RL Rotation test")
    func RLRotation() {
        // Given
        let tree = AVLTree<Int>()
        
        // When, LL상태
        tree.insert(1)
        tree.insert(3)
        tree.insert(2)
        
        // Then
        // - 회전으로 인해 균형이 맞춰짐
        #expect(tree.treeHeight == 2)
    }
}
