import Foundation
import AppsFlyerLib

/// AppsFlyer analytics repository: implements AnalyticsRepositoryProtocol and AppsFlyerLibDelegate.
/// Handles conversion/attribution callbacks and forwards them to the injected sink; use via DI.
final class AppsFlyerRepository: NSObject, AnalyticsRepositoryProtocol, AppsFlyerLibDelegate {

    private let conversionDataSink: ConversionDataSinkProtocol
    private let logger: Logging

    init(conversionDataSink: ConversionDataSinkProtocol, logger: Logging) {
        self.conversionDataSink = conversionDataSink
        self.logger = logger
        super.init()
    }

    // MARK: - AnalyticsRepositoryProtocol

    func getAnalyticsUserId() -> String? {
        AppsFlyerLib.shared().getAppsFlyerUID()
    }

    // MARK: - AppsFlyerLibDelegate

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        logger.log("AppsFlyer conversion success: \(conversionInfo)")
        conversionDataSink.updateConversionData(conversionInfo)
        NotificationCenter.default.post(name: .didReceiveConversionData, object: conversionInfo)
    }

    func onConversionDataFail(_ error: Error) {
        logger.log("AppsFlyer conversion fail: \(error.localizedDescription)")
        NotificationCenter.default.post(name: .didFailConversionData, object: error)
    }

    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
        logger.log("AppsFlyer attribution: \(attributionData)")
        NotificationCenter.default.post(name: .didReceiveAttributionData, object: attributionData)
    }

    func onAppOpenAttributionFailure(_ error: Error) {
        logger.log("AppsFlyer attribution fail: \(error.localizedDescription)")
        NotificationCenter.default.post(name: .didFailAttribution, object: error)
    }
}

// MARK: - Notification names

extension Notification.Name {

    static let didReceiveConversionData = Notification.Name("didReceiveConversionData")
    static let didFailConversionData = Notification.Name("didFailConversionData")
    static let didReceiveAttributionData = Notification.Name("didReceiveAttributionData")
    static let didFailAttribution = Notification.Name("didFailAttribution")
}
