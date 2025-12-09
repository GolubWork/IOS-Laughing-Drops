import Foundation
import Combine

final class ConversionDataStore: ObservableObject {
    static let shared = ConversionDataStore()

    @Published private(set) var conversionData: [AnyHashable: Any]? = nil

    private init() {
        #if DEBUG
        // можно задать тестовую заглушку в дебаге
        conversionData = nil
        #endif
    }

    func updateConversionData(_ data: [AnyHashable: Any]) {
        var merged = conversionData ?? [:]
        for (k, v) in data { merged[k] = v }
        conversionData = merged
        AppLogger.log("ConversionDataStore updated: \(merged)")
    }

    func clear() {
        conversionData = nil
    }
}
