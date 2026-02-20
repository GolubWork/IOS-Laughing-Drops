import Foundation

/// Default implementation of app configuration with LaughingDrops-specific values.
final class AppConfiguration: AppConfigurationProtocol {

    // MARK: - Server & identifiers

    let serverURL: String
    let storeId: String
    let firebaseProjectId: String
    let appsFlyerDevKey: String

    var storeIdWithPrefix: String {
        "id" + storeId
    }

    // MARK: - UI / copy

    let os: String
    let noInternetMessage: String
    let notificationSubtitle: String
    let notificationDescription: String

    // MARK: - Debug / feature flags

    let isDebug: Bool
    let isGameOnly: Bool
    let isWebOnly: Bool
    let isNoNetwork: Bool
    let isAskNotifications: Bool
    let isInfinityLoading: Bool

    // MARK: - Initialization

    init(
        serverURL: String = "https://laughingdropspop.com/config.php",
        storeId: String = "6756708872",
        firebaseProjectId: String = "662865312172",
        appsFlyerDevKey: String = "zjmEk65LDPa3K8s4BWnpfA",
        os: String = "iOS",
        noInternetMessage: String = "Please, check your internet connection and restart",
        notificationSubtitle: String = "Allow notifications about bonuses and promos",
        notificationDescription: String = "Stay tuned with best offers from our casino",
        isDebug: Bool = false,
        isGameOnly: Bool = false,
        isWebOnly: Bool = false,
        isNoNetwork: Bool = false,
        isAskNotifications: Bool = false,
        isInfinityLoading: Bool = false
    ) {
        self.serverURL = serverURL
        self.storeId = storeId
        self.firebaseProjectId = firebaseProjectId
        self.appsFlyerDevKey = appsFlyerDevKey
        self.os = os
        self.noInternetMessage = noInternetMessage
        self.notificationSubtitle = notificationSubtitle
        self.notificationDescription = notificationDescription
        self.isDebug = isDebug
        self.isGameOnly = isGameOnly
        self.isWebOnly = isWebOnly
        self.isNoNetwork = isNoNetwork
        self.isAskNotifications = isAskNotifications
        self.isInfinityLoading = isInfinityLoading
    }
}
