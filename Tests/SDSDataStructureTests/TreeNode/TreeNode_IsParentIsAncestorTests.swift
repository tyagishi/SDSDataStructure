@testable import SDSDataStructure
import XCTest

final class TreeNode_IsParentIsAncestorTests: XCTestCase {
    func test_isParentisAncestor_applyRootToRoot() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        XCTAssertFalse(root.isParent(of: root))
        XCTAssertFalse(root.isAncestor(of: root))
    }
    
    func test_isParentisAncestor_applyRootToChild() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        let child1 = try XCTUnwrap(root.search("Child1"))
        XCTAssertTrue(root.isParent(of: child1))
        XCTAssertTrue(root.isAncestor(of: child1))
    }
    
    func test_isParentisAncestor_applyRootToGrandChild() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        let grandChild22 = try XCTUnwrap(root.search("GrandChild22"))
        XCTAssertFalse(root.isParent(of: grandChild22))
        XCTAssertTrue(root.isAncestor(of: grandChild22))
    }
    
    func test_isParentisAncestor_applyChildToGrandChild() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        let child1 = try XCTUnwrap(root.search("Child1"))
        let child2 = try XCTUnwrap(root.search("Child2"))
        let grandChild22 = try XCTUnwrap(root.search("GrandChild22"))

        XCTAssertFalse(child1.isParent(of: grandChild22))
        XCTAssertFalse(child1.isAncestor(of: grandChild22))

        XCTAssertTrue(child2.isParent(of: grandChild22))
        XCTAssertTrue(child2.isAncestor(of: grandChild22))
    }
}
