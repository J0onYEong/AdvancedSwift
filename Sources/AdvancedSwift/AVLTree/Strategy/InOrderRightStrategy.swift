//
//  InOrderRightStrategy.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

final class InOrderRightStrategy<Value: Comparable>: TreeTraversalStrategy<Value> {
    override func getNext(_ start: Node<Value>, checker: VisitChecker<Node<Value>>) -> Node<Value>? {
        return inOrderRightTraversal(current: start, checker: checker)
    }
    
    private func inOrderRightTraversal(current: Node<Value>, checker: VisitChecker<Node<Value>>) -> Node<Value>? {
        if let rightChild = current.rightChild, !checker.isVisited(rightChild) {
            return inOrderRightTraversal(current: rightChild, checker: checker)
        }
        if !checker.isVisited(current) { return current }
        if let leftChild = current.leftChild, !checker.isVisited(leftChild) {
            return inOrderRightTraversal(current: leftChild, checker: checker)
        }
        
        if current.isRootNode { return nil }
        return inOrderRightTraversal(current: current.parent!, checker: checker)
    }
}
