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
    
    func test_moveUnderSameParent() async throws {
        let root = TreeNode.example()
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [2]) // GrandChild21
        let toIndex = IndexPath(indexes: [3]) // after GrandChild23
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},3,2,4}")
    }

    func test_moveUnderSameParent_2() async throws {
        let root = TreeNode.example()
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [2]) // GrandChild21
        let toIndex = IndexPath(indexes: [5]) // [4] also will have same meaning
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},3,4,2}")
    }
    
    func test_moveToUnderNbrElement_AsFirst() async throws {
        let root = TreeNode.example()
        print(root.structureAsString())
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [2]) // 2
        let toIndex = IndexPath(indexes: [1,0]) // after 12
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,1{2,10,11,12},3,4}")
    }
    
    func test_moveToUnderNbrElement_AsLast() async throws {
        let root = TreeNode.example()
        print(root.structureAsString())
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [2]) // 2
        let toIndex = IndexPath(indexes: [1,3]) // after 12
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12,2},3,4}")
    }


    func test_moveToParentNbr() async throws {
        let root = TreeNode.example()
        print(root.structureAsString())
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [1,2]) // 12
        let toIndex = IndexPath(indexes: [3]) // after 2
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11},2,12,3,4}")
    }
    
    func test_moveSmallTreeToSameDepth_toPrev() async throws {
        let root = TreeNode.example()
        print(root.structureAsString())
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [1]) // 12
        let toIndex = IndexPath(indexes: [0]) // after 2
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{1{10,11,12},0,2,3,4}")
    }

    func test_moveSmallTreeToSameDepth_toLater() async throws {
        let root = TreeNode.example()
        print(root.structureAsString())
        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
        
        let fromIndex = IndexPath(indexes: [1]) // 12
        let toIndex = IndexPath(indexes: [4]) // after 2
        root.move(from: fromIndex, to: toIndex)
        
        XCTAssertEqual(root.structureAsString(), "_{0,2,3,4,1{10,11,12}}")
    }

//    func test_moveSmalLTreeToChild() async throws {
//        let root = TreeNode.example()
//        print(root.structureAsString())
//        XCTAssertEqual(root.structureAsString(), "_{0,1{10,11,12},2,3,4}")
//        
//        let fromIndex = IndexPath(indexes: [1]) // 12
//        let toIndex = IndexPath(indexes: [4]) // after 2
//        root.move(from: fromIndex, to: toIndex)
//        
//        XCTAssertEqual(root.structureAsString(), "_{0,2,3,4,1{10,11,12}}")
//    }
}
