//
//  Polynomial_eval_tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/07/18
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataStructure

final class Polynomial_eval_tests: XCTestCase {
    func test_eval_noCoeff() async throws {
        let sut = try XCTUnwrap(Polynomial([1]))
        XCTAssertEqual(sut.eval(9), 1, accuracy: 0.001)
    }

    func test_eval_oneCoeff() async throws {
        let sut = try XCTUnwrap(Polynomial([1, 2]))
        // 2* 9 + 1 = 19
        XCTAssertEqual(sut.eval(9), 19, accuracy: 0.001)
    }

    func test_eval_twoCoeff() async throws {
        let sut = try XCTUnwrap(Polynomial([1, 2, 3]))
        // 3* 9*9 + 2* 9 + 1 = 262
        XCTAssertEqual(sut.eval(9), 262, accuracy: 0.001)
    }
}
