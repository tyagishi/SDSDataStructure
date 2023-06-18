//
//  Dequeue_BasicTests.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Dequeue_BasicTests: XCTestCase {
    func test_dequeue_create_addLastpopLast() async throws {
        var sut = Dequeue<Int>()

        sut.addLast(1)
        let last = try XCTUnwrap(sut.popLast())
        XCTAssertEqual(last, 1)
    }

    func test_dequeue_create_addFirstpopFirst() async throws {
        var sut = Dequeue<Int>()

        sut.addFirst(1)
        let first = try XCTUnwrap(sut.popFirst())
        XCTAssertEqual(first, 1)
    }

    func test_dequeue_create_addLastpopFirst() async throws {
        var sut = Dequeue<Int>()

        sut.addLast(1)
        let first = try XCTUnwrap(sut.popFirst())
        XCTAssertEqual(first, 1)
    }

    func test_dequeue_create_addFirstpopLast() async throws {
        var sut = Dequeue<Int>()

        sut.addFirst(1)
        let last = try XCTUnwrap(sut.popLast())
        XCTAssertEqual(last, 1)
    }

}
