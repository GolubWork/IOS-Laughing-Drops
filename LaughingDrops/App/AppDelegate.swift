import UIKit
import AppsFlyerLib
import FirebaseCore
import FirebaseMessaging
import UserNotifications

final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var orientationLock: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = AppConfig.shared.appsFlyerDevKey
        appsFlyer.appleAppID = AppConfig.shared.storeIdWithPrefix
        appsFlyer.delegate = AppsFlyerProvider.shared
        appsFlyer.isDebug = AppConfig.shared.isDebug

        appsFlyer.start()

        return true
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        AppLogger.log("APNS device token received")

        Task {
            do {
                let fcmToken = try await Messaging.messaging().token()
                AppLogger.log("FCM token received: \(fcmToken)")
                FCMTokenStore.shared.token = fcmToken
            } catch {
                AppLogger.log("Failed to get FCM token: \(error.localizedDescription)", level: .error)
            }
        }
    }

    // 🔹 Метод для возврата поддерживаемых ориентаций
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
}
