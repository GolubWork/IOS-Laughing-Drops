import SwiftUI
import UserNotifications

class NotificationSettings: ObservableObject {
    @Published var enabled: Bool = false
    @Published var time: Date = Date()
    @Published var message: String = "Don't forget to drink water!"
    @Published var hasNotificationScheduled: Bool = false

    private let keyEnabled = "notif_enabled"
    private let keyTime = "notif_time"
    private let keyMessage = "notif_message"

    init() {
        load()
        checkScheduled()
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.enabled = granted
                if granted {
                    self.schedule()
                }
            }
        }
    }

    func schedule() {
        guard enabled else { return }

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = message
        content.sound = .default

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "water_notification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)

        hasNotificationScheduled = true
        save()
    }

    func clear() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        hasNotificationScheduled = false
        save()
    }

    func checkScheduled() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.hasNotificationScheduled = requests.contains { $0.identifier == "water_notification" }
            }
        }
    }

    func save() {
        UserDefaults.standard.set(enabled, forKey: keyEnabled)
        UserDefaults.standard.set(time, forKey: keyTime)
        UserDefaults.standard.set(message, forKey: keyMessage)
    }

    func load() {
        enabled = UserDefaults.standard.bool(forKey: keyEnabled)
        if let savedTime = UserDefaults.standard.object(forKey: keyTime) as? Date {
            time = savedTime
        }
        message = UserDefaults.standard.string(forKey: keyMessage) ?? message
    }
}
