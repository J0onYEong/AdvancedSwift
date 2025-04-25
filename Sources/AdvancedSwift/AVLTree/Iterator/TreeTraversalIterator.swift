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
    private let strategy: TreeTraversalStrategy<Value>
    private var currentNode: Element?
    private var visitChecker: VisitChecker<Node<Value>> = .init()
    
    init(entryNode: EntryNode<Value>?, strategy: TreeTraversalStrategy<Value>) {
        self.strategy = strategy
        self.entry = entryNode
        self.currentNode = entryNode?.child
    }
    
    public mutating func next() -> Element? {
        guard let currentNode else { return nil }
        let nextNode = strategy.getNext(currentNode, checker: visitChecker)
        if let nextNode {
            self.currentNode = nextNode
            visitChecker.visit(nextNode)
        }
        return nextNode
    }
}
