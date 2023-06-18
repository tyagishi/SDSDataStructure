//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/06/18
//  © 2023  SmallDeskSoftware
//

import Foundation

// TODO: need to replace with swift-collections
public struct Dequeue<Element> {
    var _array: [Element]  = []

    public mutating func addLast(_ element: Element) {
        _array.append(element)
    }
    public mutating func addFirst(_ element: Element) {
        _array.insert(element, at: 0)
    }
    public mutating func popLast() -> Element? {
        guard let last = _array.last else { return nil }
        _ = _array.dropLast()
        return last
    }

    public mutating func popFirst() -> Element? {
        guard let first = _array.first else { return nil }
        _ = _array.dropFirst()
        return first
    }
    public var isEmpty: Bool {
        return _array.isEmpty
    }
    public var count: Int {
        return _array.count
    }
}

extension Dequeue {
    public mutating func addLast(_ elements: some Sequence<Element>) {
        for element in elements {
            addLast(element)
        }
    }
    public mutating func addFirst(_ elements: some Sequence<Element>) {
        for element in elements.reversed() {
            addFirst(element)
        }
    }
}
