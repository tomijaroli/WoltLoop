//
//  UserDefaultsWrapper.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults

    public var wrappedValue: Value {
        get {
            return read(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                store(value: newValue, forKey: key)
            }
        }
    }
    
    public init(key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = userDefaults
    }
    
    private func read(forKey key: String) -> Any? {
        let decoder = JSONDecoder()
        if let data = container.object(forKey: key) as? Data,
           let loadedValue = try? decoder.decode(Value.self, from: data) {
            return loadedValue
        }
        return nil
    }

    private func store(value: Value, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            container.set(encoded, forKey: key)
        }
    }
}

/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isNil: Bool { get }
}
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
