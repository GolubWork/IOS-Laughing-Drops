import Foundation
import AppTrackingTransparency

/// <summary>
/// Handles App Tracking Transparency authorization requests.
/// </summary>
final class TrackingAuthorizationManager {
    static let shared = TrackingAuthorizationManager()

    private var didRequestThisLaunch = false

    private init() {}

    /// <summary>
    /// Requests ATT permission only when status is not determined.
    /// </summary>
    @MainActor
    func requestIfNeeded() {
        guard #available(iOS 14, *) else { return }
        guard !didRequestThisLaunch else { return }
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

        didRequestThisLaunch = true
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}
