//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/07/18
//  © 2024  SmallDeskSoftware
//

import Foundation

/// Polynomial with one variable
/// note: coefficient "0" for non-constant term will be removed durint init
struct Polynomial {
    var coeffs: [Double]
    let tolerance = 0.00000001
    
    init?(_ coeffs: [Double]) {
        guard !coeffs.isEmpty else { return nil }

        // drop last zeros if exists
        self.coeffs = coeffs
        while self.coeffs.count > 1,
              let value = self.coeffs.last,
              fabs(value) < tolerance {
            self.coeffs = self.coeffs.dropLast()
        }
    }
    
    func eval(_ value: Double) -> Double {
        var retValue: Double = 0.0
        for (index, coeff) in coeffs.enumerated() {
            retValue += pow(value, Double(index)) * coeff
        }
        
        return retValue
    }
    
    mutating func differentiate() {
        var newCoeffs: [Double] = []
        for (index, coeff) in coeffs.dropFirst().enumerated() {
            newCoeffs.append(coeff * Double(index))
        }
        coeffs = newCoeffs
    }
    
    func differentiated() -> Polynomial? {
        if coeffs.count == 1 { return Polynomial([0]) }
        var newCoeffs: [Double] = []
        for (index, coeff) in coeffs.dropFirst().enumerated() {
            newCoeffs.append(coeff * Double(index+1))
        }
        return Polynomial(newCoeffs)
    }
}
