//
//  TreeNode.swift
//
//  Created by : Tomoaki Yagishita on 2022/05/26
//  © 2022  SmallDeskSoftware
//

import Foundation
import Combine
import OSLog
import SDSMacros

extension Collection {
    subscript(safe index: Index) -> Element? {
        startIndex <= index && index < endIndex ? self[index] : nil
    }
}

//@available(*, deprecated, message: "use SDSMacro.DidChangeObject")
//public protocol ObjectDidChangeProvider {
//    associatedtype ChangeDetailType
//    
//    var objectDidChange: PassthroughSubject<ChangeDetailType, Never> { get }
//}

extension OSLog {
    static let treeNodeLogger = Logger(subsystem: "com.smalldesksoftware.SDSDataStructure", category: "treeNode")
}

public enum TreeNodeChange {
    case addChild(childNodeID: TreeNode<Any>.ID, parentID: TreeNode<Any>.ID)
    case removeChild(childNodeID: TreeNode<Any>.ID, parentID: TreeNode<Any>.ID?)
    case contentUpdated(nodeID: TreeNode<Any>.ID)
}
/// tree node
///
/// to represent tree with using T as node value
///
/// node has children as child nodes
/// node has optional parent and if it is null, it must be root node
///
@DidChangeObject<TreeNodeChange>
public class TreeNode<T>: NSObject, Identifiable, ObservableObject {

    // swiftlint:disable:next nsobject_prefer_isequal
    public static func == (lhs: TreeNode<T>, rhs: TreeNode<T>) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: UUID
    public var value: T
    public var dic: [String: Any] = [:]
    
    public weak var parent: TreeNode?
    public var children: [TreeNode<T>]

    public var cancellables: Set<AnyCancellable> = Set()
    public var oDCCancellable: AnyCancellable? = nil

    public init(id: UUID = UUID(), value: T, parent: TreeNode? = nil, children: [TreeNode] = []) {
        self.id = id
        self.value = value
        self.children = children
        super.init()
        if let parent = parent {
            parent.children.append(self)
        }
        _ = children.map({ $0.parent = self })
    }
    
    public init(id: UUID = UUID(), observedValue: T, children: [TreeNode] = []) where T: ObjectDidChangeProvider {
        self.id = id
        self.value = observedValue
        self.children = children
        super.init()
        _ = children.map({ $0.parent = self })
        self.oDCCancellable = observedValue.objectDidChange.sink { _ in
            self.objectDidChange.send(TreeNodeChange.contentUpdated(nodeID: self.id))
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
}

// MARK: iteration in Depth First Search
extension TreeNode {
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
    public func localIndexUnderMyParent() -> Int? {
        guard let parent = self.parent else { return nil } // no parent, no index
        return parent.children.firstIndex(where: { $0.id == self.id })
    }
    
    public func indexPath() -> IndexPath {
        guard let parent = parent else { return IndexPath() } // super root has index: 0
        if self.id == parent.id {
            print("invalid") // assume it is root
            return IndexPath()
        }
        let parentIndex = parent.indexPath()
        
        guard let myIndex = parent.children.firstIndex(where: { $0.id == self.id }) else { fatalError("unowned child") }
        
        return parentIndex.appending(myIndex)
    }
}

extension TreeNode {
    public func node(at indexPath: IndexPath) -> TreeNode? {
        if indexPath.isEmpty { return self }
        if indexPath.count == 1 {
            return children[safe: indexPath.first!]
        }
        let firstIndex = indexPath.first!
        let nextIndexPath = indexPath[1...]
        return children[firstIndex].node(at: nextIndexPath)
    }
}

extension TreeNode where T: Equatable {
    // depth-first search
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
    // depth-first search
    public func search(match: @escaping (TreeNode) -> Bool) -> TreeNode? {
        if match(self) == true { return self }
        for child in children {
            if let node = child.search(match: match) { return node }
        }
        return nil
    }
    /// process all elements in tree along depth-first order
    /// if process return false, then exit the loop
    /// - Parameter process: closure for each element
    public func dfp(_ process: @escaping (TreeNode) -> StopKeep) -> StopKeep {
        if process(self) == .stop { return .stop}
        for child in children where child.dfp(process) == .stop {
            return .stop
        }
        return .keepGoing
    }
}
