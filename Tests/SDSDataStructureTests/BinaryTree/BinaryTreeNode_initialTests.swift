@testable import SDSDataStructure
import XCTest

final class BinaryTreeNode_initialTests: XCTestCase {

    func test_count() async throws {
        // Root {Left, Right(RightLeft,RightRight))
        let root = BinaryTreeNode.exampleWithString()
        XCTAssertEqual(root.count, 5)
        print(root)
    }}
