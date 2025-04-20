//
//  EntryNode.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

final class EntryNode<Value: Comparable & Copyable>: Node<Value> {
    private(set) var child: Node<Value>?
    override var rightChild: Node<Value>? { self.child }
    override var leftChild: Node<Value>? { self.child }
    
    override func setChild(_ node: Node<Value>) { child = node }
    override func setRightChild(_ node: Node<Value>?) { child = node }
    override func setLeftChild(_ node: Node<Value>?) { child = node }
    override func removeChild(_ node: Node<Value>) {
        if child === node { child = nil }
    }
    override func setParent(_ parentNode: Node<Value>?) { }
    
    override func copy() -> Any {
        let d_self = EntryNode(value: nil)
        if let child {
            let d_child = child.copy() as! Node<Value>
            d_self.child = d_child
            d_child.setParent(d_self)
        }
        return d_self
    }
}
