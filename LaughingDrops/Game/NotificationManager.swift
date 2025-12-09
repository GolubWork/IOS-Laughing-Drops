import SwiftUI
import UserNotifications

// MARK: - NotificationManager
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [NotificationItem] = []
    
    struct NotificationItem: Identifiable, Codable {
        let id: UUID
        var time: Date
        var message: String
    }
    
    private let storageKey = "saved_notifications"
    
    init() {
        load()
    }
    
    // MARK: Save / Load
    func save() {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            self.notifications = decoded
        }
    }
    
    // MARK: Request Permission
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    // MARK: Schedule Notification
    func schedule(_ item: NotificationItem) {
        let content = UNMutableNotificationContent()
        content.title = "Water Reminder"
        content.body = item.message
        content.sound = .default
        
        let triggerComponents = Calendar.current.dateComponents([.hour, .minute], from: item.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: Remove Notification
    func remove(_ item: NotificationItem) {
        notifications.removeAll { $0.id == item.id }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
        save()
    }
}
