//
//  TreeTraversalStrategy.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/25/25.
//

public class TreeTraversalStrategy<Value: Comparable> {
    
    public init() { }
    
    public func getNext(_ start: Node<Value>, checker: VisitChecker<Node<Value>>) -> Node<Value>? {
        return nil
    }
}
