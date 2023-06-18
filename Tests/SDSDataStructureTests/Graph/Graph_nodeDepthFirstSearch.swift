//
//  Graph_depthFirstSearch.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_depthFirstSearch: XCTestCase {
    var sut = Graph<Int>()
    var storedNode: [Int: GraphNode<Int>] = [:]
    var storedEdge: [Index2D<Int>: GraphEdge<Int>] = [:]

    func createNode() {
        for node in 1...5 {
            storedNode[node] = sut.addNode(node)
        }
    }

    func createNoLoopEdge() {
        // 1 - 2
        // 1 - 3
        // 2 - 4
        // 2 - 5
        // 3 - 5
        let edges = [(1,2), (1,3), (2,4), (2, 5), (3, 5)]
        for edge in edges {
            let index = Index2D(edge.0, edge.1)
            storedEdge[index] = sut.addEdge(from: sut.nodeCIN(edge.0), to: sut.nodeCIN(edge.1))
        }
    }

//    func test_dfs_simple_1() async throws {
//        createNode()
//        createNoLoopEdge()
//
//        var checkArray: [Int] = []
//
//        let rootNode = try XCTUnwrap(sut.nodes[1])
//        rootNode.depthFirstProcess(0, { value, pastEdges, pastNodes in
//        }, pastEdges: [], pastNodes: [rootNode]) { value, newEdge, newNode, pastEdges, pastNodes in
//            checkArray.append(newNode.nodeValue)
//            return .keepGoing
//        }
//
//        XCTAssertEqual(checkArray, [1, 2, 4, 5, 3, 5])
//
//    }



}
