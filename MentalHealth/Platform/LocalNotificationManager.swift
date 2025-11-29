//
//  LocalNotificationManager.swift
//  MentalHealth
//
//  Created by JungpyoHong on 5/1/25.
//

import UserNotifications
import Foundation

final class LocalNotificationManager {
    //Note: we can distinguish based on the test reuslt - backlog
    static let dailyReminderIdentifier = "daily_mental_health_reminder"
    static let shared = LocalNotificationManager()
    
    private init() {}
    
    func grantAccessAndScheduleIfAllowed() {
        grantAccess { granted in
            if granted {
                let hasScheduled = UserDefaults.standard.bool(forKey: "hasScheduledDailyNotification")
                if !hasScheduled {
                    // EveryDay at 9 PM.
                    self.scheduleDailyNotification(
                        identifier: LocalNotificationManager.dailyReminderIdentifier,
                        body: self.randomDailyNotificationBody(),
                        hour: 21,
                        minute: 0
                    )
                    UserDefaults.standard.set(true, forKey: "hasScheduledDailyNotification")
                }
            }
        }
    }

    private func grantAccess(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion?(granted)
        }
    }

    private func randomDailyNotificationBody() -> String {
        let randomIndex = Int.random(in: 1...6)
        let array = [String.localized(.dailyNotificationBody1),
                        String.localized(.dailyNotificationBody2),
                        String.localized(.dailyNotificationBody3),
                        String.localized(.dailyNotificationBody4),
                        String.localized(.dailyNotificationBody5),
                        String.localized(.dailyNotificationBody6)]
        return array[randomIndex - 1]
    }
    /// 매일 특정 시간에 반복 알림 예약
    func scheduleDailyNotification(
        identifier: String,
        title: String = "SoliU",
        body: String,
        hour: Int,
        minute: Int
    ) {
        // 알림 내용
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // 반복 트리거 설정
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // 요청 생성 및 추가
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🔴 Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Daily notification scheduled at \(hour):\(minute)")
            }
        }
    }

    /// 기존 알림 제거 (선택적 사용)
    func removeScheduledNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
