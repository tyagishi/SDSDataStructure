//
//  Polynomial_init_tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/07/18
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Polynomial_init_tests: XCTestCase {
    func test_init_shouldSuccess() async throws {
        let sut = Polynomial([1,2,3])
        XCTAssertNotNil(sut)
    }
    func test_init_shouldFail_noCoeff() async throws {
        let sut = Polynomial([])
        XCTAssertNil(sut)
    }
    func test_init_shouldFail_zero() async throws {
        let sut = Polynomial([0, 0, 0])
        XCTAssertNil(sut)
    }
}
