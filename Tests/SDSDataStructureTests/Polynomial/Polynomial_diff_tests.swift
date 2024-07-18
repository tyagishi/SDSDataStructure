//
//  Polynomial_diff_tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/07/18
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Polynomial_diff_tests: XCTestCase {
    func test_diff_oneCoeff() async throws {
        let sut = try XCTUnwrap(Polynomial([1]))
        let diff = try XCTUnwrap(sut.differentiated())
        XCTAssertEqual(diff.coeffs, [0])
    }
    
    func test_diff_twoCoeff() async throws {
        // f(x) = 1 + 2*x
        let sut = try XCTUnwrap(Polynomial([1, 2]))
        let diff = try XCTUnwrap(sut.differentiated())
        XCTAssertEqual(diff.coeffs, [2])
    }

    func test_diff_moreCoeff() async throws {
        // f(x) = 1 + 2*x + 3*x^3
        let sut = try XCTUnwrap(Polynomial([1, 2, 0, 3]))
        let diff = try XCTUnwrap(sut.differentiated())
        XCTAssertEqual(diff.coeffs, [2, 0, 9])
    }

}
