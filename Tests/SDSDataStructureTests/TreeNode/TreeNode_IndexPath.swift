//
//  TreeNode_IndexPath.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/30
//  © 2022  SmallDeskSoftware
//

@testable import SDSDataStructure
import XCTest

final class TreeNode_IndexPath: XCTestCase {
    func test_nodeAtIndexPath() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()

        // get first-level child
        let child2 = IndexPath(indexes: [1]) // Child2
        var value = try XCTUnwrap(root.node(at:child2)?.value)
        XCTAssertEqual(value, "Child2")

        // get second-level child (grand-child)
        let grandChild23 = IndexPath(indexes: [1, 2]) // Child2
        value = try XCTUnwrap(root.node(at:grandChild23)?.value)
        XCTAssertEqual(value, "GrandChild23")

        // get with invalid index (nil)
        let invalidIndex = IndexPath(indexes: [10])
        XCTAssertNil(root.node(at: invalidIndex))
    }
}
