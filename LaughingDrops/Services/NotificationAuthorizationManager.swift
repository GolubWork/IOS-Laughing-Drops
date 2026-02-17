import Foundation
import UserNotifications
import UIKit

/// <summary>
/// Manages system push notification authorization flow.
/// </summary>
final class NotificationAuthorizationManager {
    static let shared = NotificationAuthorizationManager()

    private init() {}

    /// <summary>
    /// Requests notification permission and registers for remote notifications.
    /// </summary>
    func requestSystemPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
