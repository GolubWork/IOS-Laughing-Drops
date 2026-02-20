import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import FirebaseCore
import FirebaseMessaging
import UserNotifications

/// Application delegate responsible for configuring Firebase, AppsFlyer,
/// push notifications, and handling application lifecycle events.
/// Holds the dependency container created at launch; LaughingDropsApp reads it and passes into views.
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    /// Current orientation lock used to restrict supported interface orientations.
    var orientationLock: UIInterfaceOrientationMask = .portrait

    /// Dependency container created at launch. Set in didFinishLaunching; LaughingDropsApp reads it and injects into views.
    private(set) var container: DependencyContainer!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        container = AppDependencies.containerForTesting ?? AppDependencies.makeDefaultContainer()
        AppDependencies.setLaunchContainer(container)

        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        guard let container = self.container else { return true }
        let appsFlyer = AppsFlyerLib.shared()
        appsFlyer.appsFlyerDevKey = container.configuration.appsFlyerDevKey
        appsFlyer.appleAppID = container.configuration.storeIdWithPrefix
        appsFlyer.delegate = container.analyticsRepository as? AppsFlyerLibDelegate
        appsFlyer.isDebug = container.configuration.isDebug

        appsFlyer.start()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
        requestTrackingAuthorizationIfNeeded()
    }

    private func requestTrackingAuthorizationIfNeeded() {
        guard #available(iOS 14, *) else { return }
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            ATTrackingManager.requestTrackingAuthorization { _ in
                self?.container?.logger.log("ATT authorization request completed")
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        container.logger.log("APNS device token received")

        Task {
            do {
                let fcmToken = try await Messaging.messaging().token()
                container.logger.log("FCM token received: \(fcmToken)")
                container.fcmTokenDataSource.token = fcmToken
            } catch {
                container.logger.log("Failed to get FCM token: \(error.localizedDescription)", level: .error)
            }
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
}
