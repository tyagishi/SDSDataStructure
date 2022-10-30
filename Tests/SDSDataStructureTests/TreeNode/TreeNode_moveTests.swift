//
//  TreeNode_moveTests.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/30
//  © 2022  SmallDeskSoftware
//

@testable import SDSDataStructure
import XCTest

final class TreeNode_moveTests: XCTestCase {
    func test_moveToSameDepthIndex() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()

        let fromIndex = IndexPath(indexes: [0]) // Child1
        let toIndex = IndexPath(indexes: [3]) // child4
        root.move(from: fromIndex, to: toIndex)

        let firstChildIndex = IndexPath(indexes: [0])
        var value = try XCTUnwrap(root.node(at: firstChildIndex)?.value)
        XCTAssertEqual(value, "Child2")
        let newChild1Index = IndexPath(indexes: [3])
        value = try XCTUnwrap(root.node(at: newChild1Index)?.value)
        XCTAssertEqual(value, "Child1")

    }
}
