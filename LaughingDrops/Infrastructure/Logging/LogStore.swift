import Foundation
import Combine

/// Stores application logs in memory and persists them to a file.
/// Provides observable log updates for UI or debugging tools.
/// Conforms to LogStorageProtocol; create via DI container and inject where needed. No singleton.
final class LogStore: ObservableObject, LogStorageProtocol {

    /// In-memory collection of log lines.
    @Published private(set) var lines: [String] = []

    private let fileURL: URL

    /// Initializes log storage, resolves file path, and loads existing logs from disk.
    init() {
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
        }
    }

    func clear() {
        lines = []
        try? FileManager.default.removeItem(at: fileURL)
    }
}
