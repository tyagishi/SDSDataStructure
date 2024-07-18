//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/07/18
//  © 2024  SmallDeskSoftware
//

import Foundation

// polynomial with one variable
struct Polynomial {
    var coeffs: [Double]
    
    init?(_ coeffs: [Double]) {
        guard !coeffs.isEmpty else { return nil }
        guard coeffs.contains(where: { fabs($0) > 0.000001 }) else { return nil }
        self.coeffs = coeffs
    }
    
    func eval(_ value: Double) -> Double {
        return 0
    }
    
    func differentiate() -> Polynomial? {
        nil
    }
}
