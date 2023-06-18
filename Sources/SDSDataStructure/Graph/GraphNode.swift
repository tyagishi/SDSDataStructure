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

    func bfs(prepChild: @escaping (_ node: GraphNode<Element>,
                                   _ traceEdges: inout [(GraphEdge<Element>, GraphNode<Element>)] ) -> Void,
             process: @escaping (_ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>) -> StopKeep) {
        var dequeue: Dequeue<(GraphEdge<Element>, GraphNode<Element>)> = Dequeue()

        var traceEdges: [(GraphEdge<Element>, GraphNode<Element>)] = []
        prepChild(self, &traceEdges)
        dequeue.addLasts(traceEdges)

        while let (traceEdge, nextNode) = dequeue.popFirst() {
            if process(traceEdge, nextNode) == .stop { break }

            var nextTraceEdge: [(GraphEdge<Element>, GraphNode<Element>)] = []
            prepChild(nextNode, &nextTraceEdge)
            dequeue.addLasts(nextTraceEdge)
        }
    }

//    func bfs<Value>( _ prepForChildren: @escaping (_ node: GraphNode<Element>,
//                                                   _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>],
//                                                   _ traceEdges: inout Dequeue<GraphEdge<Element>>,
//                                                   _ value: inout Value) -> Void,
//                     pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
//                     _ process: @escaping (_ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,_ value: Value,
//                                           _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep) {
//        var processEdge: Dequeue<GraphEdge<Element>> = Dequeue()
//
////        prepForChildren(self, pastEdges, pastNodes, 
//    }



//    func breadthFirstProcess<Value>(_ value: Value,
//                                  _ prepForChild: @escaping (_ value: inout Value, _ pastEdges: [GraphEdge<Element>], _ pastNodes: [GraphNode<Element>] ) -> Void,
//                                  pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
//                                  _ closure: @escaping (_ value: Value, _ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,
//                                                        _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep){
//        var queue = Deque<GraphNode<Element>>()
//
//        var localValue = value
//        prepForChild(&localValue, pastEdges, pastNodes)
//
//        for edge in edges {
//            let node = nbrNode(via: edge)
//            queue.addLast(node)
//        }
//
//        while let node = queue.popFirst() {
//        }
//
////        if true {
////
////
////            if pastEdges.contains(nbrEdge) { continue }
////            let nbrNode = self.nbrNode(via: nbrEdge)
////            if closure(localValue, nbrEdge, nbrNode, pastEdges, pastNodes) == .stop { continue }
////
////            let newPastEdges = pastEdges + [nbrEdge]
////            let newPastNodes = pastNodes + [nbrNode]
////            nbrNode.depthFirstProcess(localValue, prepForChild, pastEdges: newPastEdges, pastNodes: newPastNodes, closure)
////        }
//    }
}

enum StopKeep {
    case stop, keepGoing
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
