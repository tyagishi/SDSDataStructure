@testable import SDSDataStructure
import XCTest

final class TreeNode_rootNodeTests: XCTestCase {

    func test_rootNode() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        let child1 = try XCTUnwrap(root.search("Child1"))
        let child2 = try XCTUnwrap(root.search("Child2"))
        let grandChild22 = try XCTUnwrap(root.search("GrandChild22"))
        
        let rootFromChild1 = child1.rootNode()
        let rootFromChild2 = child2.rootNode()
        let rootFromGC22 = grandChild22.rootNode()
        
        XCTAssertEqual(root.id, rootFromChild1.id)
        XCTAssertEqual(root.id, rootFromChild2.id)
        XCTAssertEqual(root.id, rootFromGC22.id)
    }

}
