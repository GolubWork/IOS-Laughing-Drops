import SwiftUI

struct WebWindow: View {
    let url: URL
    
    var body: some View {
        WebViewScreen(url: url)
            .ignoresSafeArea()
    }
}
