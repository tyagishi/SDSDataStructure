//
//  Graph_dfs_bitComplecated.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_dfs_ComplexTests: XCTestCase {
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

    func test_dfs_nodeHasDifferentDepth() async throws {
        createNode()
        createNoLoopEdge()

        let prepEdgeCheck:[Index2D<Int>: [GraphEdge<Int>]] = [ Index2D(1,0): [],
                                                               Index2D(2,1): [storedEdge[Index2D(1,2)]!],
                                                               Index2D(3,2): [storedEdge[Index2D(1,2)]!, storedEdge[Index2D(2,3)]!],
                                                               Index2D(4,2): [storedEdge[Index2D(1,2)]!, storedEdge[Index2D(2,4)]!],
                                                               Index2D(4,3): [storedEdge[Index2D(1,2)]!, storedEdge[Index2D(2,3)]!, storedEdge[Index2D(3,4)]!]]
        let prepNodeCheck:[Index2D<Int>: [GraphNode<Int>]] = [ Index2D(1,0): [],
                                                               Index2D(2,1): [storedNode[1]!],
                                                               Index2D(3,2): [storedNode[1]!, storedNode[2]!],
                                                               Index2D(4,2): [storedNode[1]!, storedNode[2]!],
                                                               Index2D(4,3): [storedNode[1]!, storedNode[2]!, storedNode[3]!]]

        let processPastEdgeCheck:[Index2D<Int>: [GraphEdge<Int>]] = [ Index2D(1,0): [],
                                                                      Index2D(2,1): [],
                                                                      Index2D(3,2): [storedEdge[Index2D(1,2)]!],
                                                                      Index2D(4,2): [storedEdge[Index2D(1,2)]!],
                                                                      Index2D(4,3): [storedEdge[Index2D(1,2)]!, storedEdge[Index2D(2,3)]!] ]
        let processPastNodeCheck:[Index2D<Int>: [GraphNode<Int>]] = [ Index2D(1,0): [],
                                                                      Index2D(2,1): [storedNode[1]!],
                                                                      Index2D(3,2): [storedNode[1]!, storedNode[2]!],
                                                                      Index2D(4,2): [storedNode[1]!, storedNode[2]!],
                                                                      Index2D(4,3): [storedNode[1]!, storedNode[2]!, storedNode[3]!]]


        //        let processEdgeCheck: [Index2D<Int>, [GraphEdge<Int>]]


        var orderCheck: [Index2D<Int>] = [] // nodeValue, depth

        let rootNode = try XCTUnwrap(sut.nodes[1])
        orderCheck.append(Index2D(rootNode.nodeValue, 0))

        rootNode.dfs(0, { pastNodes, pastEdges, node, traceEdges, value in
            traceEdges = node.edgeToNext

            XCTAssertEqual(pastNodes, prepNodeCheck[Index2D(node.nodeValue, value)]!)
            XCTAssertEqual(pastEdges, prepEdgeCheck[Index2D(node.nodeValue, value)]!)

            value += 1
        }, pastEdges: [], pastNodes: [], { newEdge, newNode, value, pastEdges, pastNodes in

            XCTAssertEqual(pastEdges, processPastEdgeCheck[Index2D(newNode.nodeValue, value)]!)
            XCTAssertEqual(pastNodes, processPastNodeCheck[Index2D(newNode.nodeValue, value)]!)


            orderCheck.append(Index2D(newNode.nodeValue, value))
            return .keepGoing
        })

        XCTAssertEqual(orderCheck, [Index2D(1,0), Index2D(2,1), Index2D(3,2), Index2D(4,3), Index2D(4,2)])
    }

}
