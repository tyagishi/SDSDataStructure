@testable import SDSDataStructure
import XCTest

final class TreeNode_nextNodeTests: XCTestCase {

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
            print(expectedNodeName[index])
            let nextNode = try XCTUnwrap(node.nextNodeInDFS())
            XCTAssertEqual(nextNode.value, expectedNodeName[index])
            node = nextNode
        }
    }

}
