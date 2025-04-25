//
//  InOrderLeftStrategy.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

public final class InOrderLeftStrategy<Value: Comparable>: TreeTraversalStrategy<Value> {
    
    public override func getNext(_ start: Node<Value>, checker: VisitChecker<Node<Value>>) -> Node<Value>? {
        return inOrderLeftTraversal(current: start, checker: checker)
    }
    
    private func inOrderLeftTraversal(current: Node<Value>, checker: VisitChecker<Node<Value>>) -> Node<Value>? {
        if let leftChild = current.leftChild, !checker.isVisited(leftChild) {
            return inOrderLeftTraversal(current: leftChild, checker: checker)
        }
        if !checker.isVisited(current) { return current }
        if let rightChild = current.rightChild, !checker.isVisited(rightChild) {
            return inOrderLeftTraversal(current: rightChild, checker: checker)
        }
        
        if current.isRootNode { return nil }
        return inOrderLeftTraversal(current: current.parent!, checker: checker)
    }
}
