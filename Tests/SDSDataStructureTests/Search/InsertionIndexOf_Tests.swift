//
//  InsertionIndexOf_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/28
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

struct DC { // Data Container
    var value: Int
    init(_ value: Int) { self.value = value }
}
extension DC: Comparable {
    static func < (lhs: DC, rhs: DC) -> Bool {
        lhs.value < rhs.value
    }
}


final class InsertionIndexOf_Tests: XCTestCase {
    // [0,10,20,30,40,50].insertionIndexOf(value: 30, predicate: <) == 3    i.e. before 30
    // [0,10,20,30,40,50].insertionIndexOf(value: 30, predicate: <=) == 4   i.e. after  30
    // [0,10,20,30,40,50].insertionIndexOf(value: 35, predicate: <) == 4    i.e. before 40
    // [0,10,20,30,40,50].insertionIndexOf(value: 55, predicate: <) == 6    i.e. after  50
    // [0,10,20,30,40,50].insertionIndexOf(value: -5, predicate: <) == 0    i.e. before  0

    func test_withPredicate() throws {
        let sut = [0, 10, 20, 30, 40, 50]
        
        XCTAssertEqual(sut.insertionIndexOf(value: 30, predicate: < ), 3)
        XCTAssertEqual(sut.insertionIndexOf(value: 30, predicate: <=), 4)
        XCTAssertEqual(sut.insertionIndexOf(value: 35, predicate: < ), 4)
        XCTAssertEqual(sut.insertionIndexOf(value: 55, predicate: < ), 6)
        XCTAssertEqual(sut.insertionIndexOf(value: -5, predicate: < ), 0)
    }


    
    func test_keyWithPredicate() throws {
        let sut = [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50)]
        
        XCTAssertEqual(sut.insertionIndexOf(keyPath: \.value, value: 30, predicate: < ), 3)
        XCTAssertEqual(sut.insertionIndexOf(keyPath: \.value, value: 30, predicate: <=), 4)
        XCTAssertEqual(sut.insertionIndexOf(keyPath: \.value, value: 35, predicate: < ), 4)
        XCTAssertEqual(sut.insertionIndexOf(keyPath: \.value, value: 55, predicate: < ), 6)
        XCTAssertEqual(sut.insertionIndexOf(keyPath: \.value, value: -5, predicate: < ), 0)
    }

    func test_comparator() throws {
        let sut = [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50)]
        XCTAssertEqual(sut.insertionIndexOf(value: DC(30)), 3)
        //XCTAssertEqual(sut.insertionIndexOf(value: DC(30)), 4)  // no way to specify <=
        XCTAssertEqual(sut.insertionIndexOf(value: DC(35)), 4)
        XCTAssertEqual(sut.insertionIndexOf(value: DC(55)), 6)
        XCTAssertEqual(sut.insertionIndexOf(value: DC(-5)), 0)
    }

}
