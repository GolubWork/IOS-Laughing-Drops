import Foundation
import Combine

final class LogStore: ObservableObject {
    static let shared = LogStore()

    @Published private(set) var lines: [String] = []
    private let fileURL: URL

    private init() {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = docs.appendingPathComponent("app_logs.txt")
        loadFromFile()
    }

    private func loadFromFile() {
        if let data = try? Data(contentsOf: fileURL),
           let content = String(data: data, encoding: .utf8) {
            lines = content.components(separatedBy: .newlines)
        }
    }

    func append(message: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let line = "[\(timestamp)] \(message)"
        DispatchQueue.main.async {
            self.lines.append(line)
            self.trimIfNeeded()
            self.saveToFile()
        }
    }

    private func trimIfNeeded() {
        if lines.count > 2000 {
            lines.removeFirst(lines.count - 2000)
        }
    }

    private func saveToFile() {
        let content = lines.joined(separator: "\n")
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            // best-effort
        }
    }

    func clear() {
        lines = []
        try? FileManager.default.removeItem(at: fileURL)
    }
}
