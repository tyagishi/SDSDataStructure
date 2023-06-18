//
//  Graph_dfs_SimpleTests.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Graph_dfs_SimpleTests: XCTestCase {
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

    func test_dfs_simple() async throws {
        createNodeSimple()
        createNoLoopEdgeSimple()

        let prepEdgeCheck:[Int: [GraphEdge<Int>]] = [ 1: [],
                                                      2: [storedEdge[Index2D(1,2)]!],
                                                      3: [storedEdge[Index2D(1,2)]!, storedEdge[Index2D(2,3)]!] ]
        let prepNodeCheck:[Int: [GraphNode<Int>]] = [ 1: [],
                                                      2: [storedNode[1]!],
                                                      3: [storedNode[1]!, storedNode[2]!] ]

        let processPastEdgeCheck:[Int: [GraphEdge<Int>]] = [ 2: [ ],
                                                             3: [ storedEdge[Index2D(1,2)]! ] ]

        let processPastNodeCheck:[Int: [GraphNode<Int>]] = [ 2: [ storedNode[1]! ],
                                                             3: [ storedNode[1]!, storedNode[2]! ]]

        var checkArray: [Index2D<Int>] = [] // nodeValue, depth

        let rootNode = try XCTUnwrap(sut.nodes[1])
        checkArray.append(Index2D(rootNode.nodeValue, 0))

        rootNode.dfs(0, { pastNodes, pastEdges, node, traceEdges, value in
            traceEdges = node.edgeToNext

            XCTAssertEqual(pastNodes, prepNodeCheck[node.nodeValue]!)
            XCTAssertEqual(pastEdges, prepEdgeCheck[node.nodeValue]!)

            value += 1
        }, pastEdges: [], pastNodes: [], { newEdge, newNode, value, pastEdges, pastNodes in
            XCTAssertEqual(pastEdges, processPastEdgeCheck[newNode.nodeValue]!)
            XCTAssertEqual(pastNodes, processPastNodeCheck[newNode.nodeValue]!)
            checkArray.append(Index2D(newNode.nodeValue, value))
            return .keepGoing
        })

        XCTAssertEqual(checkArray, [Index2D(1,0), Index2D(2,1), Index2D(3,2)])
    }


//    func createNoLoopEdge2() {
//        // 1 - 2
//        // 1 - 3
//        // 2 - 4
//        // 2 - 5
//        // 3 - 4
//        // 4 - 5
//        let edges = [(1,2), (1,3), (2,4), (2, 5), (3, 4), (4, 5)]
//        for edge in edges {
//            let index = Index2D(edge.0, edge.1)
//            storedEdge[index] = sut.addEdge(from: sut.nodeCIN(edge.0), to: sut.nodeCIN(edge.1))
//        }
//    }
//    func test_traceGraph_traceOrder_sameNodeHasDifferentDepth() async throws {
//        createNode()
//        createNoLoopEdge2()
//
//        var checkArray: [Index2D<Int>] = [] // nodeValue, depth
//
//        let rootNode = try XCTUnwrap(sut.nodes[1])
//        checkArray.append(Index2D(rootNode.nodeValue, 0))
//
//        rootNode.dfs(0, { pastNodes, pastEdges, node, traceEdges, value in
//            traceEdges = node.edgeToNext
//            value += 1
//        }, pastEdges: [], pastNodes: [], { newEdge, newNode, value, pastEdges, pastNodes in
//            checkArray.append(Index2D(newNode.nodeValue, value))
//            return .keepGoing
//        })
//
//        // note: without control, Node(5) will be visited three times (from 1-2-4-5, 1-2-5, 1-3-4-5)
//        XCTAssertEqual(checkArray, [Index2D(1,0), Index2D(2,1), Index2D(4,2), Index2D(5,3), Index2D(5,2), Index2D(3,1), Index2D(4,2), Index2D(5,3)])
//    }

}
