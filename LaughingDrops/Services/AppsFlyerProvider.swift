import Foundation
import AppsFlyerLib

final class AppsFlyerProvider: NSObject, AppsFlyerLibDelegate {

    static let shared = AppsFlyerProvider()

    private override init() {
        super.init()
    }

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        AppLogger.log("AppsFlyer conversion success: \(conversionInfo)")
        ConversionDataStore.shared.updateConversionData(conversionInfo)
        NotificationCenter.default.post(name: .didReceiveConversionData, object: conversionInfo)
    }

    func onConversionDataFail(_ error: Error) {
        AppLogger.log("AppsFlyer conversion fail: \(error.localizedDescription)")
        NotificationCenter.default.post(name: .didFailConversionData, object: error)
    }

    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        AppLogger.log("AppsFlyer attribution: \(attributionData)")
        NotificationCenter.default.post(name: .didReceiveAttributionData, object: attributionData)
    }

    func onAppOpenAttributionFailure(_ error: Error) {
        AppLogger.log("AppsFlyer attribution fail: \(error.localizedDescription)")
        NotificationCenter.default.post(name: .didFailAttribution, object: error)
    }
}

extension Notification.Name {
    static let didReceiveConversionData = Notification.Name("didReceiveConversionData")
    static let didFailConversionData = Notification.Name("didFailConversionData")
    static let didReceiveAttributionData = Notification.Name("didReceiveAttributionData")
    static let didFailAttribution = Notification.Name("didFailAttribution")
}
