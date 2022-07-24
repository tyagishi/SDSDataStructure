//
//  TreeNode.swift
//
//  Created by : Tomoaki Yagishita on 2022/05/26
//  © 2022  SmallDeskSoftware
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        startIndex <= index && index < endIndex ? self[index] : nil
    }
}
public class TreeNode<T>: Identifiable, Hashable ,ObservableObject {
    public static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: UUID
    public var value: T
    
    public weak var parent: TreeNode?
    public var children: [TreeNode<T>]
    
    public init(id: UUID = UUID(), value: T, children: [TreeNode] = []) {
        self.id = id
        self.value = value
        self.children = children
        _ = children.map({$0.parent = self})
    }
    
    public func addChild(_ node: TreeNode<T>, index: Int = -1) {
        self.objectWillChange.send()
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
    
    public func addChildren(_ children:[TreeNode]) {
        for child in children {
            addChild(child)
        }
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
    
    public func rootNode() -> TreeNode<T> {
        guard let parent = self.parent else { return self }
        return parent.rootNode()
    }
    public func nextNodeInDFS() -> TreeNode<T>? {
        let currentIndex = self.indexPath()
        //guard let currentIndex.count > 0 else { return nil } // root return nil as next node
        // if I have children, move to first child
        if let firstChild = self.children.first {
            return firstChild
        }
        guard let parentNode = self.parent else { return nil } // no child, no parent
        // move to younger brother/sister who share my parent
        let selfLocalIndex = currentIndex.last!
        if let bro = parentNode.children[safe: selfLocalIndex + 1] {
            return bro
        }
        
        // need to go up to parent
        guard let grandParent = parentNode.parent else { return nil }
        let parentIndex = parentNode.indexPath()
        if let uncle = grandParent.children[safe: parentIndex.last! + 1] {
            return uncle
        }
        return nil
    }
    
    // note: root.prevNodeInDFS() will return nil
    public func prevNodeInDFS() -> TreeNode<T>? {
        guard let parentNode = self.parent else { return nil }
        let selfLocalIndex = self.indexPath().last!
        if let bro = parentNode.children[safe: selfLocalIndex - 1] {
            return bro.lastNodeInDFS()
        }
        return parentNode
        
    }
    
    public func lastNodeInDFS() -> TreeNode<T>? {
        if let lastChild = self.children.last?.lastNodeInDFS() { return lastChild }
        return self
    }
}

extension TreeNode {
    public func removeChild(_ node: TreeNode<T>) -> TreeNode<T>? {
        guard let index = children.firstIndex(where: {$0.id == node.id}) else { return nil }
        node.parent = nil
        self.objectWillChange.send()
        return children.remove(at: index)
    }
}
extension TreeNode {
    public func localIndexUnderMyParent() -> Int? {
        guard let parent = self.parent else { return nil } // no parent, no index
        return parent.children.firstIndex(where: {$0.id == self.id})
    }
    
    public func indexPath() -> IndexPath {
        guard let parent = parent else { return IndexPath() } // super root has index: 0
        if self.id == parent.id {
            print("invalid") // assume it is root
            return IndexPath()
        }
        let parentIndex = parent.indexPath()
        
        guard let myIndex = parent.children.firstIndex(where: {$0.id == self.id}) else { fatalError("unowned child") }
        
        return parentIndex.appending(myIndex)
    }
}



extension TreeNode {
    public func node(at indexPath: IndexPath) -> TreeNode? {
        if indexPath.count == 0 { return self }
        if indexPath.count == 1 {
            return children[safe: indexPath.first!]
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

extension TreeNode {
    public func move(from: IndexPath, to: IndexPath) {
        if from == to { return }
        guard let fromNode = self.node(at: from),
              let newParentNode = self.node(at: to.dropLast()) else { return }
        self.objectWillChange.send()
        _ = fromNode.parent?.removeChild(fromNode)
        let insertIndex = to.last!
        newParentNode.addChild(fromNode, index: insertIndex)
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
