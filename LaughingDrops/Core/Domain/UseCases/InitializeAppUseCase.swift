import Foundation

/// Use case: run app initialization (config checks, conversion data, server request, state resolution).
/// Conforms to AppInitializerUseCaseProtocol from AppInitialization feature.
final class InitializeAppUseCase: AppInitializerUseCaseProtocol {

    private let configuration: AppConfigurationProtocol
    private let fetchConversionDataUseCase: FetchConversionDataUseCaseProtocol
    private let analyticsRepository: AnalyticsRepositoryProtocol
    private let networkRepository: NetworkRepositoryProtocol

    init(
        configuration: AppConfigurationProtocol,
        fetchConversionDataUseCase: FetchConversionDataUseCaseProtocol,
        analyticsRepository: AnalyticsRepositoryProtocol,
        networkRepository: NetworkRepositoryProtocol
    ) {
        self.configuration = configuration
        self.fetchConversionDataUseCase = fetchConversionDataUseCase
        self.analyticsRepository = analyticsRepository
        self.networkRepository = networkRepository
    }

    func execute(pushToken: String?, hasLaunchedBefore: Bool) async -> AppState {
        if configuration.isInfinityLoading {
            return .loading
        }
        if configuration.isNoNetwork {
            return .noInternet
        }
        if configuration.isGameOnly {
            return .game
        }

        let conversionData = await fetchConversionDataUseCase.execute(timeout: 3.0)
        let afId = analyticsRepository.getAnalyticsUserId() ?? ""
        let pushTokenValue = pushToken ?? ""
        var payload = buildPayload(
            conversionData: conversionData,
            afId: afId,
            pushToken: pushTokenValue
        )

        if configuration.isDebug || configuration.isWebOnly {
            payload["af_status"] = "Non-organic"
        }

        if configuration.isWebOnly {
            do {
                let urlString = try await networkRepository.fetchWebURL(
                    usingPayload: payload as [AnyHashable: Any],
                    timeout: 30.0
                )
                if let urlString, let url = URL(string: urlString) {
                    return .web(url)
                } else if let url = URL(string: "https://example.com") {
                    return .web(url)
                }
            } catch { }
            return .game
        }

        do {
            let urlString = try await networkRepository.fetchWebURL(
                usingPayload: payload as [AnyHashable: Any],
                timeout: 30.0
            )
            let urlFromServer = urlString.flatMap { URL(string: $0) }

            if configuration.isAskNotifications, let url = urlFromServer {
                return .askNotifications(url)
            }

            if !hasLaunchedBefore {
                if let url = urlFromServer {
                    return .firstLaunch(url)
                } else {
                    return .game
                }
            }
            if let url = urlFromServer {
                return .web(url)
            }
            return .game
        } catch {
            return .game
        }
    }

    private func buildPayload(
        conversionData: [AnyHashable: Any],
        afId: String,
        pushToken: String
    ) -> [String: Any] {
        var payload: [String: Any] = [:]
        for (key, value) in conversionData {
            if let stringKey = key as? String {
                payload[stringKey] = value
            }
        }

        let bundleId = Bundle.main.bundleIdentifier ?? "unknown.bundle"
        let locale = Locale.current.identifier
        payload["af_id"] = afId
        payload["bundle_id"] = bundleId
        payload["os"] = configuration.os
        payload["store_id"] = configuration.storeIdWithPrefix
        payload["locale"] = locale
        payload["firebase_project_id"] = configuration.firebaseProjectId
        payload["push_token"] = pushToken
        if payload["af_status"] == nil {
            payload["af_status"] = "Organic"
        }

        return payload
    }
}
