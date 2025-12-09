import SwiftUI
import UserNotifications

struct FirstLaunchScreen: View {
    let url: URL
    @State private var navigateToWeb = false

    private var subtitle: String {
        AppConfig.shared.notificationSubtitle
    }

    private var descriptionText: String {
        AppConfig.shared.notificationDescription
    }

    var body: some View {
        ZStack {
            Image("notificationBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()   // ← Центрирует логотип

                // ЛОГО — строго по центру
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)

                Spacer()   // ← Новый spacer, который опускает весь UI СИЛЬНО вниз

                // >>> ВСЁ ЧТО НИЖЕ ЛОГО И ЕЩЁ НИЖЕ <<<

                VStack(spacing: 24) {

                    Text(subtitle)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 22)

                    Text(descriptionText)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 26)

                    VStack(spacing: 20) {

                        Button(action: requestPushPermission) {
                            ZStack {
                                Image("notificationButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280)

                                Text("Yes, I Want Bonuses!")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .shadow(radius: 2)
                            }
                        }

                        Button(action: { navigateToWeb = true }) {
                            Text("Skip")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .opacity(0.7)
                        }
                        .padding(.horizontal, 40)
                    }
                }

                Spacer(minLength: 70)   // ← кнопка Skip почти касается нижнего края
            }
        }
        .fullScreenCover(isPresented: $navigateToWeb) {
            WebWindow(url: url)
        }
    }

    private func requestPushPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { _, _ in
            DispatchQueue.main.async { navigateToWeb = true }
        }
    }
}
