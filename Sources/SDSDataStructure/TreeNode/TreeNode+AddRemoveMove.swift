//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/30
//  © 2022  SmallDeskSoftware
//

import Foundation


extension TreeNode {
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
    
    @discardableResult
    public func removeChild(_ node: TreeNode<T>) -> TreeNode<T>? {
        guard let index = children.firstIndex(where: {$0.id == node.id}) else { return nil }
        node.parent = nil
        self.objectWillChange.send()
        return children.remove(at: index)
    }

    public func move(from: IndexPath, to: IndexPath) {
        if from == to { return }
        guard let fromNode = self.node(at: from),
              let newParentNode = self.node(at: to.dropLast()) else { return }
        self.objectWillChange.send()
        _ = fromNode.parent?.removeChild(fromNode)
        let insertIndex = to.last!
        newParentNode.addChild(fromNode, index: insertIndex)
    }

    public func replaceNodeValue(_ newValue: T) {
        self.objectWillChange.send()
        self.value = newValue
    }

    // not used yet
//    public func replaceNode(_ node: TreeNode<T>, newNode: TreeNode<T>) {
//        self.objectWillChange.send()
//        if let nodeParent = node.parent {
//            newNode.parent = nodeParent
//        }
//        newNode.addChildren(node.children)
//        node.parent = nil
//    }
}
