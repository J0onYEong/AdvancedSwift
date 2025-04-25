//
//  InOrderLeftIterator.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

public struct InOrderLeftIterator<Value: Comparable>: IteratorProtocol {
    // State
    public typealias Element = Node<Value>
    private var currentNode: Element?
    private var visited: Set<ObjectIdentifier> = .init()
    
    init(startNode: Element?) {
        self.currentNode = startNode
    }
    
    public mutating func next() -> Element? {
        guard let currentNode else { return nil }
        let nextNode = inOrderLeftTraversal(current: currentNode)
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
    
    private func inOrderLeftTraversal(current: Element) -> Node<Value>? {
        if let leftChild = current.leftChild, !isVisited(leftChild) {
            return inOrderLeftTraversal(current: leftChild)
        }
        
        if !isVisited(current) { return current }
        
        if let rightChild = current.rightChild, !isVisited(rightChild) {
            return inOrderLeftTraversal(current: rightChild)
        }
        
        if current.isRootNode { return nil }
        return current.parent
    }
}
