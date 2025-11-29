//
//  SoliUAnalytics.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

import Foundation
import FirebaseAnalytics

public enum SoliUAnalytics {
    //현재는 static 이지만 logNavTransition 같이 다양한 function 이 추가되어 그냥 private function 으로 대체가능
    public static func logEvent(_ name: String, parameters: [AnalyticsKey: Any]? = nil) -> Void {
        Analytics.logEvent(name, parameters: toFirebaseParams(parameters))
        #if DEBUG
        DebugAnalyticsStore.shared.append(.event(
            name: name,
            parameters: parameters,
            ts: Date()
        ))
        #endif
    }

    public static func setUserID(_ id: String) {
        Analytics.setUserID(id)
        #if DEBUG
        DebugAnalyticsStore.shared.append(.userId(id, ts: Date()))
        #endif
    }

    public static func setUserProperty(_ value: String?, forName name: String) {
        Analytics.setUserProperty(value, forName: name)
        #if DEBUG
        DebugAnalyticsStore.shared.append(.userProperty(name: name, value: value, ts: Date()))
        #endif
    }

    public static func setDefaultEventParameters(_ params: [AnalyticsKey: Any]?) {
        Analytics.setDefaultEventParameters(toFirebaseParams(params))
        #if DEBUG
        DebugAnalyticsStore.shared.append(.defaultParams(params, ts: Date()))
        #endif
    }

    private static func toFirebaseParams(_ params: [AnalyticsKey: Any]?) -> [String: Any]? {
        guard let params, !params.isEmpty else { return nil }
        return params.reduce(into: [String: Any]()) { out, kv in
            out[kv.key.rawValue] = normalizeForFirebase(kv.value)
        }
    }

    private static func normalizeForFirebase(_ value: Any) -> Any {
        switch value {
        case let v as String: return v
        case let v as NSNumber: return v
        case let v as Int: return NSNumber(value: v)
        case let v as Int64: return NSNumber(value: v)
        case let v as Double: return NSNumber(value: v)
        case let v as Float: return NSNumber(value: v)
        case let v as Bool: return NSNumber(value: v ? 1 : 0)
        case let v as Date: return NSNumber(value: v.timeIntervalSince1970)
        case let v as URL: return v.absoluteString
        case let v as any AnalyticsString: return v.rawValue
        case let v as CustomStringConvertible: return v.description
        case let v as [String]: return v.joined(separator: ",")
        default:
            return String(describing: value)
        }
    }
}
