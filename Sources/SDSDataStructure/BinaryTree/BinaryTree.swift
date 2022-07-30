//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2022/07/30
//  © 2022  SmallDeskSoftware
//

import Foundation

public class BinaryTreeNode<T>: Identifiable, Hashable ,ObservableObject {
    public static func == (lhs: BinaryTreeNode<T>, rhs: BinaryTreeNode<T>) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: UUID
    @Published public var value: T
    
    @Published public private(set) var parent: BinaryTreeNode<T>? // should be maintained from parent
    @Published public private(set) var left: BinaryTreeNode<T>?
    @Published public private(set) var right: BinaryTreeNode<T>?
    
    public init(id: UUID = UUID(), value: T, left: BinaryTreeNode<T>? = nil, right: BinaryTreeNode<T>? = nil) {
        self.id = id
        self.value = value
        self.right = nil
        
        setLeft(left)
        setRight(right)
    }
    
    public func setLeft(_ node: BinaryTreeNode<T>? = nil) {
//        self.left?.parent = nil
        self.left = node
        node?.parent = self
    }
    public func setRight(_ node: BinaryTreeNode<T>? = nil) {
//        self.right?.parent = nil
        self.right = node
        node?.parent = self
    }

    public var isLeaf: Bool {
        return left == nil && right == nil
    }
//
//    public func addChild(_ node: BinaryTreeNode<T>, index: Int = -1) {
//        self.objectWillChange.send()
//        if index == -1 {
//            children.append(node)
//        } else {
//            if children.count <= index {
//                children.append(node)
//            } else {
//                children.insert(node, at: index)
//            }
//        }
//        node.parent = self
//    }
//    
//    public func node(id: BinaryTreeNode<T>.ID) -> BinaryTreeNode<T>? {
//        if id == self.id {
//            return self
//        }
//        if let child = left.node(at: id) { return child }
//        if let child = right.node(id: id) { return child }
//        return nil
//    }
//    
//    public func setParent(_ newParent: BinaryTreeNode<T>? = nil) {
//        self.parent?.
//    }
//    
//    public var isRoot: Bool {
//        return parent == nil
//    }
//    
    public var count: Int {
        var sum = 1 // self
        sum += left?.count ?? 0
        sum += right?.count ?? 0
        return sum
    }
//    
//    public func isParent(of node: BinaryTreeNode<T>) -> Bool {
//        guard let parentOfNode = node.parent else { return false } // node is rootNode
//        if parentOfNode.id == self.id { return true }
//        return false
//    }
//    
//    public func isAncestor(of node: BinaryTreeNode<T>) -> Bool {
//        guard let parentOfNode = node.parent else { return false } // node is rootNode
//        if parentOfNode.id == self.id { return true }
//        return self.isAncestor(of: parentOfNode)
//    }
//    
//    public func rootNode() -> BinaryTreeNode<T> {
//        guard let parent = self.parent else { return self }
//        return parent.rootNode()
//    }
//    public func nextNodeInDFS() -> BinaryTreeNode<T>? {
//        let currentIndex = self.indexPath()
//        //guard let currentIndex.count > 0 else { return nil } // root return nil as next node
//        // if I have children, move to first child
//        if let firstChild = self.children.first {
//            return firstChild
//        }
//        guard let parentNode = self.parent else { return nil } // no child, no parent
//        // move to younger brother/sister who share my parent
//        let selfLocalIndex = currentIndex.last!
//        if let bro = parentNode.children[safe: selfLocalIndex + 1] {
//            return bro
//        }
//        
//        // need to go up to parent
//        guard let grandParent = parentNode.parent else { return nil }
//        let parentIndex = parentNode.indexPath()
//        if let uncle = grandParent.children[safe: parentIndex.last! + 1] {
//            return uncle
//        }
//        return nil
//    }
//    
//    // note: root.prevNodeInDFS() will return nil
//    public func prevNodeInDFS() -> BinaryTreeNode<T>? {
//        guard let parentNode = self.parent else { return nil }
//        let selfLocalIndex = self.indexPath().last!
//        if let bro = parentNode.children[safe: selfLocalIndex - 1] {
//            return bro.lastNodeInDFS()
//        }
//        return parentNode
//        
//    }
//    
//    public func lastNodeInDFS() -> BinaryTreeNode<T>? {
//        if let lastChild = self.children.last?.lastNodeInDFS() { return lastChild }
//        return self
//    }
}

//
//extension BinaryTreeNode {
//    public func removeChild(_ node: BinaryTreeNode<T>) -> BinaryTreeNode<T>? {
//        guard let index = children.firstIndex(where: {$0.id == node.id}) else { return nil }
//        node.parent = nil
//        self.objectWillChange.send()
//        return children.remove(at: index)
//    }
//}
//extension BinaryTreeNode {
//    public func localIndexUnderMyParent() -> Int? {
//        guard let parent = self.parent else { return nil } // no parent, no index
//        return parent.children.firstIndex(where: {$0.id == self.id})
//    }
//    
//    public func indexPath() -> IndexPath {
//        guard let parent = parent else { return IndexPath() } // super root has index: 0
//        if self.id == parent.id {
//            print("invalid") // assume it is root
//            return IndexPath()
//        }
//        let parentIndex = parent.indexPath()
//        
//        guard let myIndex = parent.children.firstIndex(where: {$0.id == self.id}) else { fatalError("unowned child") }
//        
//        return parentIndex.appending(myIndex)
//    }
//}
//
//
//
//extension BinaryTreeNode {
//    public func node(at indexPath: IndexPath) -> BinaryTreeNode? {
//        if indexPath.count == 0 { return self }
//        if indexPath.count == 1 {
//            return children[safe: indexPath.first!]
//        }
//        let firstIndex = indexPath.first!
//        let nextIndexPath = indexPath[1...]
//        return children[firstIndex].node(at: nextIndexPath)
//    }
//}
//
//
extension BinaryTreeNode: CustomStringConvertible {
    public var description: String {
        var s = "\(value)"
        if left != nil || right != nil {
            s += " {"
            if let left = left {
                s += left.description
            }
            if left != nil && right != nil {
                s += ", "
            }
            if let right = right {
                s += right.description
            }
            s += "}"
        }
        return s
    }
}
//
//extension BinaryTreeNode where T: Equatable {
//    public func search(_ value: T) -> BinaryTreeNode? {
//        if value == self.value {
//            return self
//        }
//        for child in children {
//            if let found = child.search(value) {
//                return found
//            }
//        }
//        return nil
//    }
//}
//
//extension BinaryTreeNode {
//    public func move(from: IndexPath, to: IndexPath) {
//        if from == to { return }
//        guard let fromNode = self.node(at: from),
//              let newParentNode = self.node(at: to.dropLast()) else { return }
//        self.objectWillChange.send()
//        _ = fromNode.parent?.removeChild(fromNode)
//        let insertIndex = to.last!
//        newParentNode.addChild(fromNode, index: insertIndex)
//    }
//}
//
extension BinaryTreeNode where T == String {
    static func exampleWithString() -> BinaryTreeNode<String> {
        let rootNode = BinaryTreeNode(value: "Root", left: BinaryTreeNode(value: "Left"),
                                      right: BinaryTreeNode(value: "Right", left: BinaryTreeNode(value: "RightLeft"),
                                                            right: BinaryTreeNode(value: "RightRight")))
        return rootNode
    }
}
