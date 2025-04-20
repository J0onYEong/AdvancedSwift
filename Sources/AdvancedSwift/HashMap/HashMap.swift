//
//  HashMap.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/12/25.
//

public typealias HashMapKeyable = Hashable & Comparable & Copyable

public actor HashMap<Key: HashMapKeyable, Value> {
    // State
    private let keyTree: AVLTree<Key> = .init()
    private var hashTable: [Key: Value] = [:]
    
    public typealias ValueMerger = (Value, Value) -> Value
    private var defaultMerger: ValueMerger
    
    init(defaultMerger: @escaping ValueMerger) {
        self.defaultMerger = defaultMerger
    }
}


// MARK: Public interface
public extension HashMap {
    subscript (_ key: Key) -> Value? { get { hashTable[key] } }
    
    func insertOrMerge(key: Key, value: Value, merge: ValueMerger? = nil) {
        if let prev = hashTable[key] {
            // 키값이 이미 존재하는 경우, 업데이트
            if let merge {
                // 전달된 병합 함수 우선 사용
                hashTable[key] = merge(prev, value)
            } else {
                hashTable[key] = defaultMerger(prev, value)
            }
        } else {
            // 새로운 키값 등록
            hashTable[key] = value
            keyTree.insert(key)
        }
    }
}
