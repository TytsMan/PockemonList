//
//  Storage.swift
//  PockemonList
//
//  Created by Ivan on 23/08/2022.
//

import Foundation

@propertyWrapper
struct Storage<T> {
    
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    
    init(
        key: String,
        defaultValue: T,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: T {
        get {
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
