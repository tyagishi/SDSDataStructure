//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation
import OSLog

class GraphNode<Element> where Element: Equatable {
    var nodeValue: Element
    var edgeToNext: [GraphEdge<Element>] = [] // edges from this node
    var edgeToPrev: [GraphEdge<Element>] = [] // edges to this node

    init(_ element: Element) {
        self.nodeValue = element
    }

    var edges: [GraphEdge<Element>] { edgeToNext + edgeToPrev }
    var nextNodes: [GraphNode<Element>] { edgeToNext.map({ $0.toNode }) }
    var prevNodes: [GraphNode<Element>] { edgeToPrev.map({ $0.fromNode }) }
    var nbrNodes: [GraphNode<Element>] { edgeToNext.map({ $0.toNode }) + edgeToPrev.map({ $0.fromNode }) }
    var degree: Int { edges.count }

    func nbrNode(via edge: GraphEdge<Element>) -> GraphNode<Element> {
        if edge.fromNode.nodeValue == self.nodeValue { return edge.toNode }
        return edge.fromNode
    }

    /// traceGraph
    /// trace each node on graph from myself
    /// - Parameters:
    ///   - value: can pass value depth-dependent value
    ///   - prepForChildren: prep edges for traing otherwise no trace into children
    ///   - pastEdges: pastEdges
    ///   - pastNodes: pastNodes
    ///   - process: process something for each node, need to return .keepGoing to continue. returning .sto will stop the tracing
    func dfs<Value>(_ value: Value,
                    _ prepForChildren: @escaping (_ pastNodes: [GraphNode<Element>], _ pastEdges: [GraphEdge<Element>],
                                                  _ node: GraphNode<Element>,
                                                  _ traceEdges: inout [GraphEdge<Element>],
                                                  _ value: inout Value) -> Void,
                    pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
                    _ process: @escaping (_ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,_ value: Value,
                                          _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep) {
        var localValue = value
        var traceEdges: [GraphEdge<Element>] = []

        prepForChildren(pastNodes, pastEdges, self, &traceEdges, &localValue)
        for nbrEdge in traceEdges {
            let nbrNode = self.nbrNode(via: nbrEdge)
            let newPastNodes = pastNodes + [self]
            let newPastEdges = pastEdges + [nbrEdge]
            if process(nbrEdge, nbrNode, localValue, pastEdges, newPastNodes) == .stop { continue }

            nbrNode.dfs(localValue, prepForChildren, pastEdges: newPastEdges, pastNodes: newPastNodes, process)
        }
    }
}

extension GraphNode: Equatable where Element: Equatable {
    static func == (lhs: GraphNode<Element>, rhs: GraphNode<Element>) -> Bool { lhs.nodeValue == rhs.nodeValue }
}

extension GraphNode: Hashable where Element: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeValue)
    }
}
extension GraphNode: CustomStringConvertible where Element: CustomStringConvertible {
    var description: String {
        "\(nodeValue)"
    }
}
