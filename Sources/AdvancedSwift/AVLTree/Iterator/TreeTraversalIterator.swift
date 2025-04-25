//
//  TreeTraversalIterator.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

public enum TraversalType {
    case inOrderLeft, inOrderRight
}

public struct TreeTraversalIterator<Value: Comparable>: IteratorProtocol {
    public typealias Element = Node<Value>
    
    // State
    private let entry: Element?
    private let traversalType: TraversalType
    private var currentNode: Element?
    private var visited: Set<ObjectIdentifier> = .init()
    
    init(traversalType: TraversalType, entryNode: EntryNode<Value>?) {
        self.traversalType = traversalType
        self.entry = entryNode
        self.currentNode = entryNode?.child
    }
    
    public mutating func next() -> Element? {
        guard let currentNode else { return nil }
        let nextNode = getNext(currentNode)
        if let nextNode {
            self.currentNode = nextNode
            visit(nextNode)
        }
        return nextNode
    }
    
    private mutating func visit(_ node: Element) {
        let id = ObjectIdentifier(node)
        visited.insert(id)
    }
    
    private func isVisited(_ node: Element) -> Bool {
        let id = ObjectIdentifier(node)
        return visited.contains(id)
    }
    
    private func getNext(_ element: Element) -> Element? {
        switch traversalType {
        case .inOrderLeft:
            inOrderLeftTraversal(current: element)
        case .inOrderRight:
            inOrderRightTraversal(current: element)
        }
    }
}


// MARK: Traversal method
private extension TreeTraversalIterator {
    func inOrderLeftTraversal(current: Element) -> Node<Value>? {
        if let leftChild = current.leftChild, !isVisited(leftChild) {
            return inOrderLeftTraversal(current: leftChild)
        }
        if !isVisited(current) { return current }
        if let rightChild = current.rightChild, !isVisited(rightChild) {
            return inOrderLeftTraversal(current: rightChild)
        }
        
        if current.isRootNode { return nil }
        return inOrderLeftTraversal(current: current.parent!)
    }
    
    func inOrderRightTraversal(current: Element) -> Node<Value>? {
        if let rightChild = current.rightChild, !isVisited(rightChild) {
            return inOrderRightTraversal(current: rightChild)
        }
        if !isVisited(current) { return current }
        if let leftChild = current.leftChild, !isVisited(leftChild) {
            return inOrderRightTraversal(current: leftChild)
        }
        
        if current.isRootNode { return nil }
        return inOrderRightTraversal(current: current.parent!)
    }
}
