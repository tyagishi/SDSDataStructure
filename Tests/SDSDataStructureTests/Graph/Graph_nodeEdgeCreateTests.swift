//
//  Graph_nodeEdgeTests.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_nodeEdgeCreateTests: XCTestCase {
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

    func test_createNode_nodeCreate_retrieveNode() async throws {
        createNode()

        XCTAssertEqual(sut.nodes.count, 5)
        XCTAssertEqual(sut.nodes[1], storedNode[1])
        XCTAssertEqual(sut.nodes[2], storedNode[2])
        XCTAssertEqual(sut.nodes[3], storedNode[3])
        XCTAssertEqual(sut.nodes[4], storedNode[4])
        XCTAssertEqual(sut.nodes[5], storedNode[5])
    }
    
    func test_createNode_edgeCreate_retrieveNode() async throws {
        createNode()
        createNoLoopEdge()

        XCTAssertEqual(sut.edges.count, 5)
    }
}
