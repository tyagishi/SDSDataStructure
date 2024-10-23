//
//  TreeNode_FileSystemItem_PathHandlingTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/23
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class TreeNode_FileSystemItem_PathHandlingTests: XCTestCase {
    func prepRootNode() -> TreeNode<FileSystemItem> {
        let root = TreeNode(preferredFilename: "root", FileWrapper(directoryWithFileWrappers: [:]))
        let intermid1 = root.addDirectory(dirName: "intermid1")
        let intermid2 = root.addDirectory(dirName: "intermid2")
        let _ = intermid1.addTextFile(fileName: "Leaf11.txt", text: "Hello Leaf11")
        let _ = intermid1.addTextFile(fileName: "Leaf12.txt", text: "World Leaf12")
        let _ = intermid2.addTextFile(fileName: "Leaf21.txt", text: "World Leaf21")
        return root
    }
    
    func test_pathFromRoot_fullPathToFile() async throws {
        let sut = prepRootNode()

        XCTAssertEqual(sut.pathFromRoot(), "/")
        XCTAssertEqual(sut.fullPathToNode(), "/root")

        let intermid1 = try XCTUnwrap(sut.search(match: { $0.filename == "intermid1" }))
        XCTAssertEqual(intermid1.pathFromRoot(), "/")
        XCTAssertEqual(intermid1.fullPathToNode(), "/intermid1")

        let leaf12 = try XCTUnwrap(sut.search(match: { $0.filename == "Leaf12.txt" }))
        XCTAssertEqual(leaf12.pathFromRoot(), "/intermid1/")
        XCTAssertEqual(leaf12.fullPathToNode(), "/intermid1/Leaf12.txt")

    }
    
    func test_nodeFromPath() async throws {
        let sut = prepRootNode()

        let intermid1 = try XCTUnwrap(sut.nodeFrom(path: "/intermid1"))
        XCTAssertEqual(intermid1.filename, "intermid1")

        let leaf21 = try XCTUnwrap(sut.nodeFrom(path: "/intermid2/Leaf21.txt"))
        XCTAssertEqual(leaf21.filename, "Leaf21.txt")
    }
    

}
