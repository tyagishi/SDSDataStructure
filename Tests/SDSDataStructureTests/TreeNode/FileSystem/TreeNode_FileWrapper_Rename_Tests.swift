//
//  TreeNode_FileWrapper_Rename_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/20
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class TreeNode_FileWrapper_Rename_Tests: XCTestCase {

    func test_FileWrapper_rename() async throws {
        let root = TreeNode(preferredFilename: "root", FileWrapper(directoryWithFileWrappers: [:]))
        let intermid = root.addDirectory(dirName: "intermid")
        let leaf1 = intermid.addTextFile(fileName: "Leaf1.txt", text: "Hello")
        let leaf2 = intermid.addTextFile(fileName: "Leaf2.txt", text: "World")

        XCTAssertEqual(root.children.count, 1)
        XCTAssertEqual(root.fileWrapper.fileWrappers?.count, 1)

        XCTAssertEqual(intermid.children.count, 2)
        XCTAssertEqual(intermid.fileWrapper.fileWrappers?.count, 2)

        
        intermid.renameWithFileWrapper(to: "NewIntermid")

        let rootChildFW = try XCTUnwrap(root.fileWrapper.fileWrappers?.values)
        XCTAssertEqual(rootChildFW.count, 1)
        XCTAssertEqual(rootChildFW.contains(intermid.fileWrapper), true)

        XCTAssertEqual(intermid.children.count, 2)
        let intermidChildFW = try XCTUnwrap(intermid.fileWrapper.fileWrappers?.values)
        XCTAssertEqual(intermidChildFW.count, 2)
        XCTAssertEqual(intermidChildFW.contains(leaf1.fileWrapper), true)
        XCTAssertEqual(intermidChildFW.contains(leaf2.fileWrapper), true)

        let newFileName = try XCTUnwrap(intermid.fileWrapper.preferredFilename)
        XCTAssertEqual(newFileName, "NewIntermid")
        XCTAssertEqual(intermid.filename, "NewIntermid")
    }

}
