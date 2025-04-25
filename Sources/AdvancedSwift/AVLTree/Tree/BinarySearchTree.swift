//
//  BinarySearchTree.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

open class BinarySearchTree<Value: Comparable>: Sequence {
    // State
    private(set) var entryNode: EntryNode<Value> = .init(value: nil)
    
    var rootNode: Node<Value>? { entryNode.child }
    
    // Iteration
    private(set) var traversalStrategy: TreeTraversalStrategy<Value>
    
    public required init(traversalStrategy: TreeTraversalStrategy<Value> = InOrderLeftStrategy()) {
        self.traversalStrategy = traversalStrategy
    }
    
    public var isEmpty: Bool { rootNode == nil }
    func setEntry(_ node: EntryNode<Value>) { self.entryNode = node }
    func createNode(value: Value, parent: Node<Value>) -> Node<Value> {
        Node<Value>(value: value, parent: parent)
    }
    
    enum BSTNodeRemoval {
        case noSub(targetParent: Node<Value>?)
        case subExists(subNode: Node<Value>, prevSubNodeParent: Node<Value>?)
    }
    func onRemoval(removalInfo: BSTNodeRemoval) { }
    func onInsertion(insertedNode: Node<Value>) { }
    
    public func copy() -> Self {
        let d_self = Self.init()
        d_self.traversalStrategy = self.traversalStrategy
        d_self.setEntry(entryNode.copy())
        return d_self
    }
}


// MARK: Public interface: insert & remove
public extension BinarySearchTree {
    /// 값을 트리에 추가합니다.
    final func insert(_ value: Value) {
        // 루트 노드가 비어 있는 경우
        if rootNode == nil {
            let newRootNode = createNode(value: value, parent: entryNode)
            self.entryNode.setChild(newRootNode)
            self.onInsertion(insertedNode: newRootNode)
            return
        }
        
        // 위치 찾기
        var compareNode: Node<Value> = rootNode!
        while true {
            if compareNode.value < value {
                // 삽입 값이 더 큰 경우, 오른쪽 노드 접근
                guard let rightChild = compareNode.rightChild else { break }
                compareNode = rightChild
            } else if compareNode.value > value {
                // 삽입 값이 더 작은 경우, 왼쪽 노드 접근
                guard let leftChild = compareNode.leftChild else { break }
                compareNode = leftChild
            } else {
                // 중복 요소 배제
                return
            }
        }
        
        // 새로운 노드 생성 및 삽입
        let newNode = createNode(value: value, parent: compareNode)
        compareNode.setChild(newNode)
        self.onInsertion(insertedNode: newNode)
    }
    
    /// 값이 트리에 존재할 경우 값을 삭제합니다.
    @discardableResult
    final func remove(_ value: Value) -> MemoryLeakChecker? {
        guard let rootNode else { return nil }
        var targetNode: Node<Value> = rootNode
        while true {
            if targetNode.value < value {
                guard let rightChild = targetNode.rightChild else { return nil }
                targetNode = rightChild
            } else if targetNode.value > value {
                guard let leftChild = targetNode.leftChild else { return nil }
                targetNode = leftChild
            } else {
                // 동일한 값을 가지는 노드를 발견한 경우
                break
            }
        }
        
        // 대체자 찾기
        var subNode: Node<Value>?
        if let minNodeInRight = targetNode.getMinNodeInRightLayer() {
            subNode = minNodeInRight
        } else if let maxNodeInLeft = targetNode.getMaxNodeInLeftLayer() {
            subNode = maxNodeInLeft
        }
        
        var prevSubNodeParent: Node<Value>?
        if let subNode {
            // 대체노드가 있는 경우
            if let subNodeParent = subNode.parent, !(subNodeParent is EntryNode) {
                prevSubNodeParent = subNode.parent
            }
            subNode.parent?.removeChild(subNode)
            subNode.setParent(nil)
            
            if let parentNode = targetNode.parent {
                // 대상의 부모를 대체 노드로 이전
                subNode.setParent(parentNode)
                parentNode.setChild(subNode)
            }
            if let rightNode = targetNode.rightChild, rightNode !== subNode {
                // 대상의 오른쪽 자식을 이전
                subNode.setRightChild(rightNode)
                rightNode.setParent(subNode)
                targetNode.setRightChild(nil)
            }
            if let leftNode = targetNode.leftChild, leftNode !== subNode {
                // 대상의 왼쪽 자식을 이전
                subNode.setLeftChild(leftNode)
                leftNode.setParent(subNode)
                targetNode.setLeftChild(nil)
            }
        }
        
        // 대상 노드 삭제
        let targetNodeParent = targetNode.parent
        targetNode.parent?.removeChild(targetNode)
        targetNode.setParent(nil)
        
        if let subNode {
            onRemoval(removalInfo: .subExists(
                subNode: subNode,
                prevSubNodeParent: prevSubNodeParent === targetNode ? nil : prevSubNodeParent
            ))
        } else {
            onRemoval(removalInfo: .noSub(targetParent: targetNodeParent))
        }
        
        return MemoryLeakChecker(object: targetNode)
    }
    
    final func clear() {
        guard let rootNode else { return }
        postOrderTraversal(node: rootNode, action: { node in
            node.setLeftChild(nil)
            node.setRightChild(nil)
            node.setParent(nil)
        })
        entryNode.removeChild(rootNode)
    }
}


// MARK: Public interface: sorted list
public extension BinarySearchTree {
    final func getAscendingList(maxCount: UInt? = nil) -> [Value] {
        var list: [Value] = []
        var iterator = TreeTraversalIterator(
            entryNode: entryNode,
            strategy: InOrderLeftStrategy()
        )
        while let nextElement = iterator.next() {
            list.append(nextElement.value)
            if let maxCount, list.count >= maxCount { break }
        }
        return list
    }
    
    final func getDescendingList(maxCount: UInt? = nil) -> [Value] {
        var list: [Value] = []
        var iterator = TreeTraversalIterator(
            entryNode: entryNode,
            strategy: InOrderRightStrategy()
        )
        while let nextElement = iterator.next() {
            list.append(nextElement.value)
            if let maxCount, list.count >= maxCount { break }
        }
        return list
    }
}


// MARK: Iterator
public extension BinarySearchTree {
    @discardableResult
    func setTraversalStrategy(_ strategy: TreeTraversalStrategy<Value>) -> Self {
        self.traversalStrategy = strategy
        return self
    }
 
    func makeIterator() -> TreeTraversalIterator<Value> {
        let copied = self.copy()
        return TreeTraversalIterator(
            entryNode: copied.entryNode,
            strategy: traversalStrategy
        )
    }
}


// MARK: 내부 순회 함수
private extension BinarySearchTree {
    func postOrderTraversal(node: Node<Value>, action: (Node<Value>) -> ()) {
        if let leftChild = node.leftChild {
            postOrderTraversal(node: leftChild, action: action)
        }
        if let rightChild = node.rightChild {
            postOrderTraversal(node: rightChild, action: action)
        }
        action(node)
    }
}


// MARK: For test
extension BinarySearchTree {
    func clearWithCheckers() -> [MemoryLeakChecker] {
        guard let rootNode else { return [] }
        var checkers: [MemoryLeakChecker] = []
        postOrderTraversal(node: rootNode, action: { node in
            checkers.append(.init(object: node))
        })
        self.clear()
        return checkers
    }
}
