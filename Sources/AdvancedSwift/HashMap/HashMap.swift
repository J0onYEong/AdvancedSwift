//
//  HashMap.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/12/25.
//

public typealias HashMapKeyable = Hashable & Comparable & Copyable

public final class HashMap<Key: HashMapKeyable, Value> {
    // State
    private var keyTree: AVLTree<Key> = .init()
    private var hashTable: [Key: Value] = [:]
    
    public init() { }
    
    public func copy() -> HashMap<Key, Value> {
        let d_self = HashMap<Key, Value>()
        d_self.keyTree = self.keyTree.copy()
        d_self.hashTable = self.hashTable
        return d_self
    }
}


// MARK: Public interface
public extension HashMap {
    subscript (_ key: Key) -> Value? {
        get { hashTable[key] }
        set {
            if hashTable[key] == nil {
                // 새로운 키값인 경우
                keyTree.insert(key)
            }
            hashTable[key] = newValue
        }
    }
    
    func removeValue(_ forKey: Key) {
        keyTree.remove(forKey)
        hashTable.removeValue(forKey: forKey)
    }
    
    enum SortOrder { case ASC, DESC }
    /// Return sorted list whose range is 0..<maxCount
    func keys(order: SortOrder, maxCount: UInt? = nil) -> [Key] {
        let bound: UInt = maxCount ?? UInt(keys.count)
        guard bound != 0 else { return [] }
        switch order {
        case .ASC:
            return keyTree.getAscendingList(maxCount: bound)
        case .DESC:
            return keyTree.getDiscendingList(maxCount: bound)
        }
    }
    
    var keys: [Key] { Array(hashTable.keys) }
    var values: [Value] { Array(hashTable.values) }
    
    func clear() {
        hashTable.removeAll()
        keyTree.clear()
    }
}
