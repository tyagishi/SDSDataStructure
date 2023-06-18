//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation

extension GraphNode {
    // MARK: to stop depthFirst Trace, return false from closure
//    func traceGraph<Value>(_ value: Value,
//                           _ prepForChildren: @escaping (_ node: GraphNode<Element>,
//                                                         _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>],
//                                                         _ traceEdges: inout [GraphEdge<Element>],
//                                                         _ value: inout Value) -> StopKeep,
//                           pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
//                           _ process: @escaping (_ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,_ value: Value,
//                                                 _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep) {
//
//    }


//    // MARK: to stop depthFirst Trace, return false from closure
//    func depthFirstProcess<Value>(_ value: Value,
//                                  _ prepForChild: @escaping (_ value: inout Value, _ pastEdges: [GraphEdge<Element>], _ pastNodes: [GraphNode<Element>] ) -> Void,
//                                  pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
//                                  _ closure: @escaping (_ value: Value, _ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,
//                                                        _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep){
//        var localValue = value
//        prepForChild(&localValue, pastEdges, pastNodes)
//        for nbrEdge in edges {
//            if pastEdges.contains(nbrEdge) { continue }
//            let nbrNode = self.nbrNode(via: nbrEdge)
//            if closure(localValue, nbrEdge, nbrNode, pastEdges, pastNodes) == .stop { continue }
//
//            let newPastEdges = pastEdges + [nbrEdge]
//            let newPastNodes = pastNodes + [nbrNode]
//            nbrNode.depthFirstProcess(localValue, prepForChild, pastEdges: newPastEdges, pastNodes: newPastNodes, closure)
//        }
//    }
//    func depthFirstDirectionalProcess<Value>(_ value: Value,
//                                             _ prepForChild: @escaping (_ value: inout Value, _ pastEdges: [GraphEdge<Element>], _ pastNodes: [GraphNode<Element>] ) -> Void,
//                                             pastEdges: [GraphEdge<Element>], pastNodes: [GraphNode<Element>],
//                                             _ closure: @escaping (_ value: Value, _ newEdge: GraphEdge<Element>,_ newNode: GraphNode<Element>,
//                                                                   _ pastEdges: [GraphEdge<Element>],_ pastNodes: [GraphNode<Element>]) -> StopKeep){
//        var localValue = value
//        prepForChild(&localValue, pastEdges, pastNodes)
//        for nbrEdge in edgeToNext {
//            if pastEdges.contains(nbrEdge) { continue }
//            let nbrNode = self.nbrNode(via: nbrEdge)
//            if closure(localValue, nbrEdge, nbrNode, pastEdges, pastNodes) == .stop { continue }
//
//            let newPastEdges = pastEdges + [nbrEdge]
//            let newPastNodes = pastNodes + [nbrNode]
//            nbrNode.depthFirstDirectionalProcess(localValue, prepForChild, pastEdges: newPastEdges, pastNodes: newPastNodes, closure)
//        }
//    }
}
