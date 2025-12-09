import SwiftUI

@main
struct LaughingDropsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appVM = AppViewModel()
    @StateObject var history = HistoryStore() 

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appVM)
                .environmentObject(history)
                .onAppear {
                    appVM.start()
                }
        }
    }
}

struct RootView: View {
    @EnvironmentObject var appVM: AppViewModel

    var body: some View {
        Group {
            switch appVM.state {
            case .loading:
                LoadingView()
            case .firstLaunch(let url):
                FirstLaunchScreen(url: url)
            case .game:
                MainTabView()
            case .web(let url):
                WebWindow(url: url)
            case .error(let msg):
                Text("Error: \(msg)")
                    .foregroundColor(.red)
            case .askNotifications(let url):
                FirstLaunchScreen(url: url)
            case .noInternet:
                NoInternetScreen(retryAction: {
                    appVM.start()
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
