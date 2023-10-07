//
//  DictionaryWithDefault_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2023/10/07
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class DictionaryWithDefault_Tests: XCTestCase {
    
    func test_defaultValue() throws {
        let sut = DictionaryWithDefault<Int,Int>(defaultValue: 0)
        
        XCTAssertEqual(sut[-5], 0)
        XCTAssertEqual(sut[3], 0)
        XCTAssertEqual(sut[9], 0)
    }
    
    func test_calcBasedOnDefaultValue() throws {
        var sut = DictionaryWithDefault<Int,Int>(defaultValue: 0)
        
        sut[3] = sut[2] + 1
        XCTAssertEqual(sut[3], 1)
        sut[5] = sut[3] + 2
        XCTAssertEqual(sut[5], 3)
        sut[12] = sut[0] + sut[5]
        XCTAssertEqual(sut[12], 3)
    }

    
}
