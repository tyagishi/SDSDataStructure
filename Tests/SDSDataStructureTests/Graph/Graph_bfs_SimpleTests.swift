//
//  Graph_bfs_SimpleTests.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_bfs_SimpleTests: XCTestCase {
    var sut = Graph<Int>()
    var storedNode: [Int: GraphNode<Int>] = [:]
    var storedEdge: [Index2D<Int>: GraphEdge<Int>] = [:]

    func createNodeSimple() {
        for node in 1...3 {
            storedNode[node] = sut.addNode(node)
        }
    }

    func createNoLoopEdgeSimple() {
        let edges = [(1,2), (2,3)]
        for edge in edges {
            let index = Index2D(edge.0, edge.1)
            storedEdge[index] = sut.addEdge(from: sut.nodeCIN(edge.0), to: sut.nodeCIN(edge.1))
        }
    }

    func test_generalBFS_withGraph() async throws {
        createNodeSimple()
        createNoLoopEdgeSimple()

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

        XCTAssertEqual(orderCheck, [1, 2, 3])
    }
       
}
