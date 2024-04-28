//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/19
//  © 2023  SmallDeskSoftware
//

import Foundation

// MARK: binary search
// [0,10,20,30,40,50].insertionIndexOf(value: 30, predicate: <) == 3    i.e. before 30
// [0,10,20,30,40,50].insertionIndexOf(value: 30, predicate: <=) == 4   i.e. after  30
// [0,10,20,30,40,50].insertionIndexOf(value: 35, predicate: <) == 4    i.e. before 40
// [0,10,20,30,40,50].insertionIndexOf(value: 55, predicate: <) == 6    i.e. after  50
// [0,10,20,30,40,50].insertionIndexOf(value: -5, predicate: <) == 0    i.e. before  0
extension RandomAccessCollection {
    public typealias OrderPredicate = (Iterator.Element, Iterator.Element) -> Bool
    public func insertionIndexOf(value: Iterator.Element, predicate: OrderPredicate) -> Index {
        var low = startIndex, high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if predicate(self[mid], value) { low = index(mid, offsetBy: 1)
            } else { high = mid }
        }
        return low
    }
    
    public func insertionIndexOf<T>(keyPath: KeyPath<Iterator.Element,T>, value: T, predicate: (T, T) -> Bool) -> Index {
        var low = startIndex, high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if predicate(self[mid][keyPath: keyPath], value) { low = index(mid, offsetBy: 1)
            } else { high = mid }
        }
        return low
    }
}

extension RandomAccessCollection where Element: Comparable {
    public func insertionIndexOf(element: Iterator.Element) -> Index {
        var low = startIndex, high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if self[mid] < element { low = index(mid, offsetBy: 1)
            } else { high = mid }
        }
        return low
    }
}

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
