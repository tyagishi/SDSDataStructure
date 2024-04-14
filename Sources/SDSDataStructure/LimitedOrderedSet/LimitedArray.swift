//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2022/07/25
//  © 2022  SmallDeskSoftware
//

import Foundation

/// ordered set with limited number
///
/// to represent ordered collection with limited number
///
/// note: currently LimitedOrderedSet uses Array as backing store
///       may switch to OrderedSet in swift-collections in the future
///
public class LimitedOrderedSet<T: Equatable>: ObservableObject {
    @Published public private(set) var array: [T]
    let max: Int
    
    public init(_ selected: [T], max: Int) {
        self.array = selected
        self.max = max
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public func contains(_ one: T) -> Bool {
        return array.contains(where: { $0 == one })
    }

    @discardableResult
    public func insert(_ newOne: T) -> Bool {
        guard !contains(newOne) else { return false }
        objectWillChange.send()
        array.append(newOne)
        if array.count > max {
            array.removeFirst()
        }
        return true
    }
    
    public func toggle(_ one: T) {
        if !contains(one) {
            self.insert(one)
        } else {
            self.remove(one)
        }
    }

    @discardableResult
    public func remove(_ existingOne: T) -> Bool {
        guard let index = array.firstIndex(where: { $0 == existingOne }) else { return false }
        objectWillChange.send()
        array.remove(at: index)
        return true
    }
}

extension LimitedOrderedSet: Equatable where T: Equatable {
    public static func == (lhs: LimitedOrderedSet<T>, rhs: LimitedOrderedSet<T>) -> Bool {
        return lhs.array == rhs.array
    }
}
