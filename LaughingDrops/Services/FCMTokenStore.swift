final class FCMTokenStore {
    static let shared = FCMTokenStore()
    private init() {}
    var token: String?
}
