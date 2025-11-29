//
//  AnalyticsKey.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

import Foundation

public protocol AnalyticsString: ExpressibleByStringLiteral, CustomStringConvertible, Hashable, Encodable {
    var rawValue: String { get set }
}

extension AnalyticsString {
    public var description: String { rawValue }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public struct AnalyticsKey: AnalyticsString {
    public var rawValue: String
    public init(stringLiteral value: String) {
        rawValue = value
    }
    
    public static let page: AnalyticsKey = "page"
    
    public static let button: AnalyticsKey = "button"
    public static let timestamp: AnalyticsKey = "timestamp"
    public static let from: AnalyticsKey = "from"
    public static let to: AnalyticsKey = "to"

    public enum Test {
        public static var test: AnalyticsKey = "test"
    }
}
