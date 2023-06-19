//
//  Graph_bfs_ComplexTests.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_bfs_ComplexTests: XCTestCase {
    var sut = Graph<Int>()
    var storedNode: [Int: GraphNode<Int>] = [:]
    var storedEdge: [Index2D<Int>: GraphEdge<Int>] = [:]

    func createNode() {
        for node in 1...4 {
            storedNode[node] = sut.addNode(node)
        }
    }

    func createNoLoopEdge() {
        let edges = [(1,2), (2,3), (2,4), (3, 4)]
        for edge in edges {
            let index = Index2D(edge.0, edge.1)
            storedEdge[index] = sut.addEdge(from: sut.nodeCIN(edge.0), to: sut.nodeCIN(edge.1))
        }
    }

    func test_generalBFS_withGraph() async throws {
        createNode()
        createNoLoopEdge()

        let rootNode = try XCTUnwrap(sut.nodes[1])

        var orderCheck: [Int] = []
        orderCheck.append(rootNode.nodeValue)

        bfs(rootNode.nodeValue, prepChild: { nodeValue in
            let node = self.sut.nodeCIN(nodeValue)
            return node.edgeToNext.map({ $0.toNode.nodeValue})
        }, process: { nodeValue in
            orderCheck.append(nodeValue)
            return .keepGoing
        })

        XCTAssertEqual(orderCheck, [1, 2, 3, 4, 4])

    }
}
