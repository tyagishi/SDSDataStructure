//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation
import OSLog

extension OSLog {
    static var graphLogger = Logger(subsystem: "com.smalldesksoftware.datastructure", category: "graph")
}


class Graph<Element> where Element: Hashable {
    var nodes: [Element: GraphNode<Element>] = [:]
    var edges: [Index2D<Element>: GraphEdge<Element>] = [:]

    @discardableResult
    func addNode(_ element: Element) -> GraphNode<Element> {
        let node = GraphNode(element)
        nodes[element] = node
        return node
    }

    @discardableResult
    func nodeCIN(_ element: Element) -> GraphNode<Element> {
        guard let node = nodes[element] else {
            return addNode(element)
        }
        return node
    }

    @discardableResult
    func addEdge(from: GraphNode<Element>, to: GraphNode<Element>) -> GraphEdge<Element> {
        let edge = GraphEdge(from, to)
        from.edgeToNext.append(edge)
        to.edgeToPrev.append(edge)
        edges[Index2D(from.nodeValue, to.nodeValue)] = edge
        return edge
    }
}

extension Graph: CustomStringConvertible where Element: CustomStringConvertible{
    var description: String {
        var ret = ""
        for node in nodes.values {
            let fromDesc = node.edgeToPrev.map({$0.toNode.nodeValue.description}).joined(separator: ",")
            let toDesc = node.edgeToNext.map({$0.toNode.nodeValue.description}).joined(separator: ",")
            ret += "[\(node.nodeValue) [from:\(fromDesc)] [to:\(toDesc)] ]"
        }
        return ret
    }
}
