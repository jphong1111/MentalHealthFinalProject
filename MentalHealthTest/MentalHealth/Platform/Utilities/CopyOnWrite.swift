//
//  CopyOnWrite.swift
//  MentalHealth
//
//  Created by JungpyoHong on 9/28/25.
//

import Foundation

@propertyWrapper
public struct CopyOnWrite<Value: Any> {
    private var ref: MutableRef<Value>
    
    public var wrappedValue: Value {
        get {
            ref.value
        }
        set {
            if isKnownUniquelyReferenced(&ref) {
                ref.value = newValue
            } else {
                ref = MutableRef(newValue)
            }
        }
    }
    
    public init(wrappedValue: Value) {
        ref = MutableRef(wrappedValue)
    }
}

extension CopyOnWrite: Equatable where Value: Equatable {
    public static func == (lhs: CopyOnWrite<Value>, rhs: CopyOnWrite<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension CopyOnWrite: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
