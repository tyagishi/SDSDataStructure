@testable import SDSDataStructure
import XCTest

final class TreeNode_IsRootTests: XCTestCase {

    func test_isRoot() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        let child1 = try XCTUnwrap(root.search("Child1"))
        let child2 = try XCTUnwrap(root.search("Child2"))
        let grandChild22 = try XCTUnwrap(root.search("GrandChild22"))
        XCTAssertTrue(root.isRoot)
        XCTAssertFalse(child1.isRoot)
        XCTAssertFalse(child2.isRoot)
        XCTAssertFalse(grandChild22.isRoot)
    }
}
