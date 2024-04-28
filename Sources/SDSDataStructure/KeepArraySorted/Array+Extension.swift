//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2024/04/28
//  © 2024  SmallDeskSoftware
//

import Foundation

extension Array where Element: Comparable {
    public mutating func insertAtSorted(_ element: Element) {
        let index = self.insertionIndexOf(element: element)
        self.insert(element, at: index)
    }
    
    public func insertedAtSorted(_ element: Element) -> [Element] {
        var ret = self
        let index = ret.insertionIndexOf(element: element)
        ret.insert(element, at: index)
        return ret
    }
}

extension Array {
    public mutating func insertAtSorted(_ element: Element, predicate: OrderPredicate) {
        let index = self.insertionIndexOf(value: element, predicate: predicate)
        self.insert(element, at: index)
    }

    public func insertedAtSorted(_ element: Element, predicate: OrderPredicate) -> [Element] {
        var ret = self
        let index = ret.insertionIndexOf(value: element, predicate: predicate)
        ret.insert(element, at: index)
        return ret
    }
}
