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
        // f(x) = 1 + 2*x + 3*x*x
        let sut = Polynomial([1,2,3])
        XCTAssertNotNil(sut)
    }
    func test_init_shouldSuccess_oneZero() async throws {
        // f(x) = 0
        let sut = Polynomial([0])
        XCTAssertNotNil(sut)
    }

    func test_init_shouldSuccess_manyZero() async throws {
        // f(x) = 0
        let sut = Polynomial([0, 0, 0, 0])
        XCTAssertNotNil(sut)
        // but should have [0] as coeffs
        XCTAssertEqual(sut!.coeffs.count, 1)
        XCTAssertEqual(sut!.coeffs[0], 0)
    }
    func test_init_shouldSuccess_manyZeroMore() async throws {
        // f(x) = 0
        let sut = Polynomial([0, 0, 0, 0, 2, 0, 0])
        XCTAssertNotNil(sut)
        // but should have [0] as coeffs
        XCTAssertEqual(sut!.coeffs, [0, 0, 0, 0, 2])
    }

    func test_init_shouldFail_noCoeff() async throws {
        // can not understand, always it should be evalauted as zero. So no sense.
        // f(x) = empty , note: this is NOT same with [0]
        let sut = Polynomial([])
        XCTAssertNil(sut)
    }
}
