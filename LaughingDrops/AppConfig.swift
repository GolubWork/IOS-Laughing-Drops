import Foundation

final class AppConfig {

    static let shared = AppConfig()

    private init() {}

    let serverURL: String = "https://laughingdropspop.com/config.php"
    let os: String = "iOS"
    let storeId: String = "6756708872"
    let firebaseProjectId: String = "662865312172"
    let appsFlyerDevKey: String = "zjmEk65LDPa3K8s4BWnpfA"

    
    
    let noInternetMessage: String = "Please, check your internet connection and restart"
    let notificationSubtitle: String = "Allow notifications about bonuses and promos"
    let notificationDescription: String = "Stay tuned with best offers from our casino"


    
    let isDebug: Bool = false
    let isGameOnly: Bool = true
    let isWebOnly: Bool = false
    let isNoNetwork: Bool = false
    let isAskNotifications: Bool = false
    let isInfinityLoading: Bool = false

    var storeIdWithPrefix: String {
        return "id" + storeId
    }
}
