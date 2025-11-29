//
//  DebugAnalyticsStore.swift
//  MentalHealth
//
//  Created by JungpyoHong on 10/4/25.
//

#if DEBUG
import Foundation

enum DebugAnalyticsRecord {
    case event(name: String, parameters: [AnalyticsKey: Any]?, ts: Date)
    case userProperty(name: String, value: String?, ts: Date)
    case userId(String, ts: Date)
    case defaultParams([AnalyticsKey: Any]?, ts: Date)
}

extension Notification.Name {
    static let debugAnalyticsUpdated = Notification.Name("debugAnalyticsUpdated")
}

final class DebugAnalyticsStore {
    static let shared = DebugAnalyticsStore()
    private let cap = 500
    private let lock = NSLock()
    private(set) var records: [DebugAnalyticsRecord] = []

    func append(_ r: DebugAnalyticsRecord) {
        lock.lock(); defer { lock.unlock() }
        records.append(r)
        if records.count > cap { records.removeFirst(records.count - cap) }
        NotificationCenter.default.post(name: .debugAnalyticsUpdated, object: nil)
    }

    func dumpJSON() -> String {
        lock.lock(); defer { lock.unlock() }
        let arr: [[AnalyticsKey: Any]] = records.map { rec in
            switch rec {
            case let .event(name, params, ts):
                return ["type":"event","name":name,"parameters":params ?? [:],"timestamp":ts.timeIntervalSince1970]
            case let .userProperty(name, value, ts):
                return ["type":"user_property","name":name,"value":value as Any,"timestamp":ts.timeIntervalSince1970]
            case let .userId(id, ts):
                return ["type":"user_id","value":id as Any,"timestamp":ts.timeIntervalSince1970]
            case let .defaultParams(p, ts):
                return ["type":"default_params","parameters":p ?? [:],"timestamp":ts.timeIntervalSince1970]
            }
        }
        let data = try? JSONSerialization.data(withJSONObject: arr, options: [.prettyPrinted, .sortedKeys])
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
    }
}
#endif
