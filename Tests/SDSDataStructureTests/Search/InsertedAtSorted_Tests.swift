//
//  InsertedAtSorted_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/28
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

fileprivate struct DC: Comparable { // Data Container
    var value: Int
    init(_ value: Int) { self.value = value }
    static func < (lhs: DC, rhs: DC) -> Bool {
        lhs.value < rhs.value
    }
}

final class InsertedAtSorted_Tests: XCTestCase {
    func test_IntComparable() throws {
        let sut = [0, 10, 20, 30, 40, 50]

        XCTAssertEqual(sut.insertedAtSorted(30), [0, 10, 20, 30, 30, 40, 50])
        XCTAssertEqual(sut.insertedAtSorted(35), [0, 10, 20, 30, 35, 40, 50])
        XCTAssertEqual(sut.insertedAtSorted(55), [0, 10, 20, 30, 40, 50, 55])
        XCTAssertEqual(sut.insertedAtSorted(-5), [-5, 0, 10, 20, 30, 40, 50])
    }

    func test_DCComparable() throws {
        let sut = [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50)]

        XCTAssertEqual(sut.insertedAtSorted(DC(30)), [DC(0), DC(10), DC(20), DC(30), DC(30), DC(40), DC(50)])
        XCTAssertEqual(sut.insertedAtSorted(DC(35)), [DC(0), DC(10), DC(20), DC(30), DC(35), DC(40), DC(50)])
        XCTAssertEqual(sut.insertedAtSorted(DC(55)), [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50), DC(55)])
        XCTAssertEqual(sut.insertedAtSorted(DC(-5)), [DC(-5),DC( 0), DC(10), DC(20), DC(30), DC(40), DC(50)])
    }
}
