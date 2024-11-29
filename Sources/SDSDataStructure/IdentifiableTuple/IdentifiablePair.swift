//
//  IdentifiablePair.swift
//  SDSDataStructure
//
//  Created by Tomoaki Yagishita on 2024/11/29.
//

import Foundation

public struct IdentifiablePair<F,S>: Identifiable {
    public var id: UUID
    public var first: F
    public var second: S
    public init(id: UUID = UUID(),_ first: F,_ second: S) {
        self.id = id
        self.first = first
        self.second = second
    }
}
