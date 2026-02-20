import SwiftUI

struct BackgroundView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // 🔹 Фон на весь экран
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 🔹 Контент поверх фона
            content
        }
    }
}
