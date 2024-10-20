//
//  UnderstandFileWrapperTests.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/20
//  © 2024  SmallDeskSoftware
//

import XCTest

final class UnderstandFileWrapperTests: XCTestCase {



    func test_changeParent() throws {
        let file1 = FileWrapper(regularFileWithContents: "Hello".data(using: .utf8)!)
        let file2 = FileWrapper(regularFileWithContents: "World".data(using: .utf8)!)
        let parent1 = FileWrapper(directoryWithFileWrappers: ["HelloKey": file1,
                                                              "WorldKey": file2])

        // note: try to hand over child files to another filewrapper...
        let _ = FileWrapper(directoryWithFileWrappers: parent1.fileWrappers ?? [:])
        
        let parent1Children_before = try XCTUnwrap(parent1.fileWrappers)
        XCTAssertEqual(parent1Children_before.count, 2)

        parent1.removeFileWrapper(file1)
        parent1.removeFileWrapper(file2)
        let parent1Children_after = try XCTUnwrap(parent1.fileWrappers)
        XCTAssertEqual(parent1Children_after.count, 0)
    }
}
