//
//  MutableRef.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/28/25.
//

import Foundation

@dynamicMemberLookup public final class MutableRef<Value> {
    public var value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
    
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
