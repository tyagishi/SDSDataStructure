@testable import SDSDataStructure
import XCTest

final class TreeNode_nextprevNodeTests: XCTestCase {

    func test_nextNodeInDFS() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        
        let expectedNodeName = ["Child1", "Child2",
                                "GrandChild21",
                                "GrandChild22",
                                "GrandChild23",
                                "Child3",
                                "Child4",
                                "Child5"]
        
        var node = root
        
        for index in 0..<expectedNodeName.count {
            let nextNode = try XCTUnwrap(node.nextNodeInDFS())
            XCTAssertEqual(nextNode.value, expectedNodeName[index])
            node = nextNode
        }
    }
    func test_prevNodeInDFS() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        
        let expectedNodeName = ["Child4",
                                "Child3",
                                "GrandChild23",
                                "GrandChild22",
                                "GrandChild21",
                                "Child2",
                                "Child1"]
        
        var node = try XCTUnwrap(root.search("Child5"))
        for index in 0..<expectedNodeName.count {
            print("check \(node.value)")
            let prevNode = try XCTUnwrap(node.prevNodeInDFS())
            XCTAssertEqual(prevNode.value, expectedNodeName[index])
            node = prevNode
        }
    }
}
