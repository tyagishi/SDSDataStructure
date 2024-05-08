//
//  DictionaryWithDefault.swift
//
//  Created by : Tomoaki Yagishita on 2023/10/07
//  © 2023  SmallDeskSoftware
//

import Foundation

/// DWD is a short name for DictionaryWithDefault
public typealias DWD = DictionaryWithDefault

/// This Dictionay store default value internally.
///
/// Storing default value in dicitionary would be helpful like following.
/// ```swift
/// var dic = DictionaryWithDefault<Int:String>(defaultValue: "Zero")
/// let value = dic[0, default: "Zero"]
/// print(value) // Zero
/// ```
///
/// In contrast standard dictionary receives defualt value in subscript.
/// ```swift
/// var dic = [1: "One", 2: "Two"]
/// let value = dic[0, default: "Zero"]
/// print(value) // Zero
/// ```
///
///
public struct DictionaryWithDefault<Key: Hashable, Value> {
    var dictionary: [Key: Value]
    var defaultValue: Value

    /// keys
    public var keys: Dictionary<Key, Value>.Keys {
        dictionary.keys
    }
    /// values
    public var values: Dictionary<Key, Value>.Values {
        dictionary.values
    }

    /// initialize dictionary with default value
    public init(_ dic: [Key: Value] = [:], defaultValue: Value) {
        self.dictionary = dic
        self.defaultValue = defaultValue
    }
    
    /// return value for the key. Iff value is not there, default value will be returned.
    ///
    /// default value was spcified in init.
    public subscript(key: Key) -> Value {
        get {
            dictionary[key, default: defaultValue]
        }
        set(newValue) {
            dictionary[key] = newValue
        }
    }

    /// check where dictionary has a value for give key
    public func hasValue(for key: Key) -> Bool {
        return dictionary[key] != nil
    }

    /// print-out all key-value pairs with using print
    public func debugPrint() {
        for key in self.keys {
            print("\(key): \(self[key])")
        }
    }
}
