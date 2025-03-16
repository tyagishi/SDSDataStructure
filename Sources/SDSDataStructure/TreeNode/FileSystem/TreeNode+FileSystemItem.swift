//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/23
//  © 2024  SmallDeskSoftware
//

import Foundation

extension TreeNode where T == FileSystemItem {
    public func node(at path: any StringProtocol) -> TreeNode<FileSystemItem>? {
        var pathComponents = path.split(separator: "/")
        var node: TreeNode<FileSystemItem> = self.rootNode()
        while let component = pathComponents.first {
            guard let childNode = node.children.filter({$0.filename == String(component)}).first else { return nil }
            node = childNode
            pathComponents.removeFirst()
        }
        return node
    }

    public func pathFromRoot() -> String {
        var pathString = ""
        var node = self
        while let parent = node.parent {
            if parent.parent == nil { break }
            pathString = parent.filename + "/" + pathString
            node = parent
        }
        return "/" + pathString
    }
    
    public func fullPathToNode() -> String {
        return self.pathFromRoot() + self.filename
    }
}
