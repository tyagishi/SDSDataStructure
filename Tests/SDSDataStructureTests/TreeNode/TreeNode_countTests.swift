@testable import SDSDataStructure
import XCTest

final class Tests: XCTestCase {
    func test_count() async throws {
        // Root {Child1, Child2 {GrandChild21, GrandChild22, GrandChild23}, Child3, Child4, Child5}
        let root = TreeNode.exampleWithString()
        XCTAssertEqual(root.count, 9)
    }
}
