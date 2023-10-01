//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/10/01
//  © 2023  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

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
    static func example() -> TreeNode<String> {
        let rootNode = TreeNode(value: "_", children: [
            TreeNode(value: "0", children: []),
            TreeNode(value: "1", children: [
                TreeNode(value: "10", children: []),
                TreeNode(value: "11", children: []),
                TreeNode(value: "12", children: []),
            ]),
            TreeNode(value: "2", children: []),
            TreeNode(value: "3", children: []),
            TreeNode(value: "4", children: []),
        ])
        return rootNode
    }
    
    func structureAsString() -> String {
        var s = "\(value)"
        if !children.isEmpty {
            s += "{" + children.map { $0.structureAsString() }.joined(separator: ",") + "}"
        }
        return s
    }
}
