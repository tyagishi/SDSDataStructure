//
//  InsertAtSorted_Tests.swift
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

@MainActor
final class InsertAtSorted_Tests: XCTestCase {
    func test_IntComparable() throws {
        XCTContext.runActivity(named: "30", block: { _ in
            var sut = [0, 10, 20, 30, 40, 50]
            sut.insertAtSorted(30)
            XCTAssertEqual(sut, [0, 10, 20, 30, 30, 40, 50])
        })
        XCTContext.runActivity(named: "35", block: { _ in
            var sut = [0, 10, 20, 30, 40, 50]
            sut.insertAtSorted(35)
            XCTAssertEqual(sut, [0, 10, 20, 30, 35, 40, 50])
        })
        XCTContext.runActivity(named: "55", block: { _ in
            var sut = [0, 10, 20, 30, 40, 50]
            sut.insertAtSorted(55)
            XCTAssertEqual(sut, [0, 10, 20, 30, 40, 50, 55])
        })
        XCTContext.runActivity(named: "-5", block: { _ in
            var sut = [0, 10, 20, 30, 40, 50]
            sut.insertAtSorted(-5)
            XCTAssertEqual(sut, [-5, 0, 10, 20, 30, 40, 50])
        })
    }

//    func test_DCComparable() throws {
//        let sut = [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50)]
//
//        XCTAssertEqual(sut.insertedAtSorted(DC(30)), [DC(0), DC(10), DC(20), DC(30), DC(30), DC(40), DC(50)])
//        XCTAssertEqual(sut.insertedAtSorted(DC(35)), [DC(0), DC(10), DC(20), DC(30), DC(35), DC(40), DC(50)])
//        XCTAssertEqual(sut.insertedAtSorted(DC(55)), [DC(0), DC(10), DC(20), DC(30), DC(40), DC(50), DC(55)])
//        XCTAssertEqual(sut.insertedAtSorted(DC(-5)), [DC(-5),DC( 0), DC(10), DC(20), DC(30), DC(40), DC(50)])
//    }
}
