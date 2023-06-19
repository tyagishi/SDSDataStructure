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
    typealias OrderPredicate = (Iterator.Element, Iterator.Element) -> Bool
    func insertionIndexOf(value: Iterator.Element, predicate: OrderPredicate) -> Index {
        var low = startIndex, high = endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if predicate(self[mid], value) { low = index(mid, offsetBy: 1)
            } else { high = mid }
        }
        return low
    }
}
