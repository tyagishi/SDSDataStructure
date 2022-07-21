//
//  TreeNode.swift
//
//  Created by : Tomoaki Yagishita on 2022/05/26
//  © 2022  SmallDeskSoftware
//

import Foundation

public class TreeNode<T>: Identifiable, ObservableObject {
    public var id: UUID
    public var value: T

    public weak var parent: TreeNode?
    public var children = [TreeNode<T>]()

    public init(value: T) {
        self.id = UUID()
        self.value = value
        self.parent = nil
    }

    public init(value: T, children: [TreeNode]) {
        self.id = UUID()
        self.value = value
        self.children = children
        _ = children.map({$0.parent = self})
    }

    public func addChild(_ node: TreeNode<T>, index: Int = -1) {
        if index == -1 {
            children.append(node)
        } else {
            if children.count <= index {
                children.append(node)
            } else {
                children.insert(node, at: index)
            }
        }
        node.parent = self
    }
    public func node(id: TreeNode<T>.ID) -> TreeNode<T>? {
        if id == self.id {
            return self
        }
        for child in children {
            if let found = child.node(id: id) {
                return found
            }
        }
        return nil
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var count: Int {
        var sum = 1 // self
        for child in children {
            sum += child.count
        }
        return sum
    }

    public func isParent(of node: TreeNode<T>) -> Bool {
        guard let parentOfNode = node.parent else { return false } // node is rootNode
        if parentOfNode.id == self.id { return true }
        return false
    }
    
    public func isAncestor(of node: TreeNode<T>) -> Bool {
        guard let parentOfNode = node.parent else { return false } // node is rootNode
        if parentOfNode.id == self.id { return true }
        return self.isAncestor(of: parentOfNode)
    }
}

extension TreeNode where T: Equatable {
    public func removeChild(_ node: TreeNode<T>) -> TreeNode<T>? {
        guard let index = children.firstIndex(where: {$0.value == node.value}) else { return nil }
        node.parent = nil
        return children.remove(at: index)
    }
    public func indexPath() -> IndexPath {
        guard let parent = parent else { return IndexPath() } // super root has index: 0
        if self.id == parent.id {
            print("invalid") // assume it is root
            return IndexPath()
        }
        let parentIndex = parent.indexPath()
        
        guard let myIndex = parent.children.firstIndex(where: {$0.value == self.value}) else { fatalError("unowned child") }
        
        return parentIndex.appending(myIndex)
    }
}

extension TreeNode {
    public func node(at indexPath: IndexPath) -> TreeNode {
        if indexPath.count == 0 { return self }
        if indexPath.count == 1 {
            return children[indexPath.first!]
        }
        let firstIndex = indexPath.first!
        let nextIndexPath = indexPath[1...]
        return children[firstIndex].node(at: nextIndexPath)
    }
}


extension TreeNode: CustomStringConvertible {
    public var description: String {
        var s = "\(value)"
        if !children.isEmpty {
            s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return s
    }
}

extension TreeNode where T: Equatable {
    public func search(_ value: T) -> TreeNode? {
        if value == self.value {
            return self
        }
        for child in children {
            if let found = child.search(value) {
                return found
            }
        }
        return nil
    }
}

extension TreeNode where T: Equatable {
    public func move(from: IndexPath, to: IndexPath) {
        if from == to { return }
        print("move")
        self.objectWillChange.send()
        let fromNode = self.node(at: from)
        //print(fromNode.value)
        var newParent = to
        newParent.removeLast()
        let newParentNode = self.node(at: newParent)
        _ = fromNode.parent?.removeChild(fromNode)
        let insertIndex = to.last!
        newParentNode.addChild(fromNode, index: insertIndex)
        //print(newParentNode.value)
    }
}

extension TreeNode where T == String {
    static func exampleWithString() -> TreeNode<String> {
        let rootNode = TreeNode(value: "Root", children: [
            TreeNode(value: "Child1", children: []),
            TreeNode(value: "Child2", children: [
                TreeNode(value: "GrandChild21", children: []),
                TreeNode(value: "GrandChild22", children: []),
                TreeNode(value: "GrandChild23", children: []),
            ]),
            TreeNode(value: "Child3", children: []),
            TreeNode(value: "Child4", children: []),
            TreeNode(value: "Child5", children: []),
        ])
        return rootNode
    }
}
