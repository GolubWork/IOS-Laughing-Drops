import Foundation
import os

struct AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "LaughingDrops"
    private static let logger = Logger(subsystem: subsystem, category: "App")

    static func log(_ message: String, level: OSLogType = .default) {
        // Console (OSLog)
        switch level {
        case .debug:
            logger.debug("\(message)")
        case .error:
            logger.error("\(message)")
        case .fault:
            logger.fault("\(message)")
        default:
            logger.log("\(message)")
        }

        // Append to file for unified console
        LogStore.shared.append(message: message)
    }
}
