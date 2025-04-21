//
//  HashMapTests.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/20/25.
//

import Testing
@testable import AdvancedSwift

struct HashMapKeySyncTest {
    @Test("해쉬테이블과 트리로 관리되는 키가 동기화되는지 확인한다.")
    func getList() {
        // Given
        let map = HashMap<Int, Int>()
        
        // When
        let list = Array(Set((0..<10000).map({ _ in Int.random(in: 1..<100000) })))
        list.forEach { number in
            map[number] = -1
        }
        
        // Then
        #expect(map.keys.count == map.keys(order: .ASC).count)
        #expect(map.keys.sorted(by: >) == map.keys(order: .DESC))
    }
}

struct HashMapCRUDTests {
    @Test("전체삭제 테스트")
    func checkClear() {
        // Given
        let map = HashMap<Int, Int>()
        let list = Array(Set((0..<10000).map({ _ in Int.random(in: 1..<100000) })))
        list.forEach { number in
            map[number] = -1
        }
        
        // When
        map.clear()
        
        // Then
        #expect(map.keys.isEmpty)
        #expect(map.keys(order: .ASC).isEmpty)
    }
}
