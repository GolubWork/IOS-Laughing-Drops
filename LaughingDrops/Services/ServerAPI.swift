import Foundation

enum ServerAPIError: Error {
    case invalidURL
    case transportError(Error)
    case invalidResponse
    case serverError(String)
}

final class ServerAPI {
    static let shared = ServerAPI()
    private init() {}

    func fetchWebURL(using conversionData: [AnyHashable: Any]?,
                     timeout: TimeInterval = 10) async throws -> String? {

        guard let url = URL(string: AppConfig.shared.serverURL) else {
            throw ServerAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = conversionData ?? [:]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        AppLogger.log("ServerAPI: POST payload: \(payload)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await withThrowingTaskGroup(of: (Data, URLResponse).self) { group in
                group.addTask {
                    try await URLSession.shared.data(for: request)
                }

                // timeout task
                group.addTask {
                    try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                    throw ServerAPIError.invalidResponse // will cancel
                }

                let result = try await group.next()!
                group.cancelAll()
                return result
            }
        } catch {
            throw ServerAPIError.transportError(error)
        }

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw ServerAPIError.invalidResponse
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ServerAPIError.invalidResponse
        }

        AppLogger.log("ServerAPI: response JSON: \(json)")

        if let ok = json["ok"] as? Bool, ok,
           let urlString = json["url"] as? String, !urlString.isEmpty {
            return urlString
        } else {
            return nil
        }
    }
}
