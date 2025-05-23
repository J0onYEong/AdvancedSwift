//
//  Node.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

open class Node<Value: Comparable> {
    // State
    let value: Value!
    private(set) weak var parent: Node<Value>?
    private(set) var leftChild: Node<Value>?
    private(set) var rightChild: Node<Value>?
    
    var isRootNode: Bool { (parent as? EntryNode) != nil }
    
    required public init(value: Value?, parent: Node<Value>? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func setParent(_ parentNode: Node<Value>?) {
        self.parent = parentNode
    }
    
    func setChild(_ node: Node<Value>) {
        if value < node.value {
            setRightChild(node)
        } else if value > node.value {
            setLeftChild(node)
        } else { fatalError() }
    }
    
    func setLeftChild(_ node: Node<Value>?) {
        self.leftChild = node
    }
    
    func setRightChild(_ node: Node<Value>?) {
        self.rightChild = node
    }
    
    func removeChild(_ node: Node<Value>) {
        if leftChild === node { setLeftChild(nil) }
        else if rightChild === node { setRightChild(nil) }
    }
    
    public func copy() -> Node<Value> {
        let d_value = self.value
        let d_self = Self.init(value: d_value)
        if let leftChild {
            let d_left = leftChild.copy() as! Self
            d_self.leftChild = d_left
            d_left.parent = d_self
        }
        if let rightChild {
            let d_right = rightChild.copy() as! Self
            d_self.rightChild = d_right
            d_right.parent = d_self
        }
        return d_self
    }
}


// MARK: Public interface: 대체자 찾기
extension Node {
    func getMinNodeInRightLayer() -> Node<Value>? {
        guard let rightChild else { return nil }
        var currentNode = rightChild
        while true {
            guard let currentLeftChild = currentNode.leftChild else { break }
            currentNode = currentLeftChild
        }
        return currentNode
    }
    
    func getMaxNodeInLeftLayer() -> Node<Value>? {
        guard let leftChild else { return nil }
        var currentNode = leftChild
        while true {
            guard let currentRightChild = currentNode.rightChild else { break }
            currentNode = currentRightChild
        }
        return currentNode
    }
}
