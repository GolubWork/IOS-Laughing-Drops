import SwiftUI

/// Holds the app view model built from the launch container. Created once when LaughingDropsApp initializes.
@MainActor
private final class AppViewModelHolder: ObservableObject {
    let container: DependencyContainer
    lazy var viewModel: AppViewModel = AppViewModel(
        initializeAppUseCase: container.initializeAppUseCase,
        pushTokenProvider: container.pushTokenProvider
    )
    init(container: DependencyContainer) {
        self.container = container
    }
}

/// Main application entry point. AppDelegate creates the dependency container at launch and assigns it
/// so LaughingDropsApp can read it once to build the view model and inject into the hierarchy.
@main
@MainActor
struct LaughingDropsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var holder: AppViewModelHolder
    @StateObject private var history = HistoryStore()

    init() {
        _holder = StateObject(wrappedValue: AppViewModelHolder(container: AppDependencies.launchContainer!))
    }

    var body: some Scene {
        let container = appDelegate.container
        return WindowGroup {
            RootView()
                .environment(\.dependencyContainer, container)
                .environmentObject(holder.viewModel)
                .environmentObject(history)
                .onAppear { holder.viewModel.start() }
        }
    }
}
