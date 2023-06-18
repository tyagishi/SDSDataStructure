//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation

class GraphEdge<Element>: Identifiable, Equatable where Element: Equatable {
    let id = UUID()
    var fromNode: GraphNode<Element>
    var toNode: GraphNode<Element>
    init(_ from: GraphNode<Element>,_ to: GraphNode<Element>) {
        self.fromNode = from
        self.toNode = to
    }

    static func == (lhs: GraphEdge<Element>, rhs: GraphEdge<Element>) -> Bool {
        lhs.id == rhs.id
    }
}

extension GraphEdge: Hashable where Element: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(fromNode.nodeValue)
        hasher.combine(toNode.nodeValue)
    }
}

extension GraphEdge: CustomStringConvertible where Element: CustomStringConvertible {
    var description: String {
        "\(fromNode.nodeValue) - \(toNode.nodeValue)"
    }
}
