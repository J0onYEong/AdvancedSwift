//
//  Heap.swift
//  AdvancedSwift
//
//  Created by choijunios on 5/13/25.
//

struct Heap<T> {
    // State
    private var list: [T] = []
    private let comparator: (T, T) -> Bool
    
    
    var count: Int { list.count }
    var isEmpty: Bool { list.isEmpty }

    
    enum HeapType {
        case min, max
    }
    
    
    init(heapType: HeapType) where T: Comparable {
        switch heapType {
        case .max:
            comparator = { $0 > $1 }
        case .min:
            comparator = { $0 < $1 }
        }
    }
    
    
    init(compare: @escaping (T, T) -> Bool) {
        self.comparator = compare
    }
}


// MARK:
extension Heap {
    mutating func insert(_ element: T) {
        list.append(element)
        repositionFromBottom(startIndex: list.endIndex-1)
    }
    
    func top() -> T? { list.first }
    
    @discardableResult
    mutating func popTop() -> T? {
        if let top = list.first {
            if list.count > 1 {
                let lastElement = list.removeLast()
                list[list.startIndex] = lastElement
                repositionFromTop(startIndex: list.startIndex)
            } else {
                list.removeLast()
            }
            return top
        } else {
            return nil
        }
    }
}


// MARK: Reposition
private extension Heap {
    func getParentIndex(index: Int) -> Int? {
        guard index > 0 else { return nil }
        return (index-1) / 2
    }
    func getLeftChildIndex(index: Int) -> Int? {
        let left = 2*index + 1
        return left >= list.count ? nil : left
    }
    func getRightChildIndex(index: Int) -> Int? {
        guard let left = getLeftChildIndex(index: index) else { return nil }
        let right = left + 1
        return right >= list.count ? nil : right
    }
    mutating func compareAndSwap(challengerIndex ci: Int, targetIndex ti: Int) -> Bool {
        let result = comparator(list[ci], list[ti])
        if result {
            // swap
            let challenger = list[ci]
            list[ci] = list[ti]
            list[ti] = challenger
        }
        return result
    }
    
    mutating func repositionFromTop(startIndex si: Int) {
        let lci = getLeftChildIndex(index: si)
        let rci = getRightChildIndex(index: si)
        
        var ci: Int
        if let lci, let rci {
            // 양쪽자식이 모두 있는 경우
            ci = comparator(list[lci], list[rci]) ? lci : rci
        } else if let lci {
            // 왼쪽자식만 있는 경우
            ci = lci
        } else {
            // 자식이 없는 경우
            return
        }
        if compareAndSwap(challengerIndex: ci, targetIndex: si) {
            // Swap이 발생한 경우 재귀호출
            return repositionFromTop(startIndex: ci)
        }
    }
    
    mutating func repositionFromBottom(startIndex si: Int) {
        if let pi = getParentIndex(index: si) {
            // 부모가 존재하는 경우
            if compareAndSwap(challengerIndex: si, targetIndex: pi) {
                // Swap이 발생한 경우 재귀호출
                return repositionFromBottom(startIndex: pi)
            }
        }
    }
}
