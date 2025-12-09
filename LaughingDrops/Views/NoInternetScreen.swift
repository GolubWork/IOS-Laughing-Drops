import SwiftUI

struct NoInternetScreen: View {
    let retryAction: () -> Void

    private var message: String {
        AppConfig.shared.noInternetMessage
    }

    var body: some View {
        ZStack {
            // Фон на весь экран
            Image("internetBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Центровочный контейнер
            VStack {
                Spacer()

                // Карточка с изображением frame; внутри — контент
                ZStack {
                    // Если asset "frame" есть — используем его как фон
                    if UIImage(named: "frame") != nil {
                        Image("frame")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: min(UIScreen.main.bounds.width * 0.9, 420))
                            .overlay(
                                // Контент поверх изображения
                                VStack(spacing: 16) {
                                    Image(systemName: "wifi.slash")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.red)

                                    Text(message)
                                        .multilineTextAlignment(.center)
                                        .font(.title3)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 24)
                            )
                    } else {
                        // Fallback — простая карточка, если картинки нет
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.95))
                            .frame(maxWidth: min(UIScreen.main.bounds.width * 0.9, 420))
                            .shadow(radius: 10)
                            .overlay(
                                VStack(spacing: 16) {
                                    Image(systemName: "wifi.slash")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(.red)

                                    Text(message)
                                        .multilineTextAlignment(.center)
                                        .font(.title3)
                                        .padding(.horizontal, 20)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 24)
                            )
                    }
                }
                .padding(.horizontal)
                .accessibilityElement(children: .contain)

                Spacer()
            }
            .padding()
        }
    }
}
