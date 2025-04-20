//
//  AVLTree.swift
//  AdvancedSwift
//
//  Created by choijunios on 4/10/25.
//

final public class AVLTree<Value: Comparable & Copyable>: BinarySearchTree<Value> {

    override func createNode(value: Value, parent: Node<Value>) -> Node<Value> {
        AVLNode(value: value, parent: parent)
    }
    
    override func onInsertion(insertedNode node: Node<Value>) {
        if let parent = node.parent as? AVLNode {
            do {
                try parent.startBalancing()
            } catch {
                print("[\(Self.self)] \(error)")
            }
        }
    }
    
    override func onRemoval(removalInfo: BinarySearchTree<Value>.BSTNodeRemoval) {
        do {
            switch removalInfo {
            case .noSub(let targetParent):
                guard let targetParent = targetParent as? AVLNode else { return }
                try targetParent.startBalancing()
            case .subExists(let subNode, let prevSubNodeParent):
                if let prevSubNodeParent {
                    guard let subNode = subNode as? AVLNode else { return }
                    subNode.updateFactors()
                    guard let prevSubNodeParent = prevSubNodeParent as? AVLNode else { return }
                    try prevSubNodeParent.startBalancing()
                } else {
                    guard let subNode = subNode as? AVLNode else { return }
                    try subNode.startBalancing()
                }
            }
        } catch {
            print("[\(Self.self)] \(error)")
        }
    }
    
    public func copy() -> Self {
        let d_self = AVLTree<Value>()
        d_self.setEntry(entryNode.copy() as! EntryNode)
        return d_self as! Self
    }
}


// MARK: Tree height
public extension AVLTree {
    var treeHeight: Int {
        guard let rootNode else { return 0 }
        let avlRootNode = rootNode as! AVLNode
        return avlRootNode.height+1
    }
}
