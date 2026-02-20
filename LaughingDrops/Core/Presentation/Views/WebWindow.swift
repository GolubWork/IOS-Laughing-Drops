import SwiftUI

/// Fullscreen wrapper view for displaying web content using WebViewScreen.
struct WebWindow: View {
    let url: URL
    
    var body: some View {
        WebViewScreen(url: url)
            .ignoresSafeArea()
    }
}
