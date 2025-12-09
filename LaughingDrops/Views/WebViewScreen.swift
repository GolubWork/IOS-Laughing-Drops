import SwiftUI
import WebKit

struct WebViewScreen: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(initialURL: url)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        let initialURL: URL

        init(initialURL: URL) {
            self.initialURL = initialURL
        }

        // 1️⃣ Лечит ошибку -1007 (слишком много редиректов)
        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {

            let nsError = error as NSError

            if nsError.domain == NSURLErrorDomain &&
                nsError.code == NSURLErrorHTTPTooManyRedirects {

                print("⚠️ Too many redirects, reloading last known URL…")

                let failingURL = nsError.userInfo[NSURLErrorFailingURLErrorKey] as? URL
                let reloadURL = failingURL ?? initialURL

                webView.load(URLRequest(url: reloadURL))
            }
        }

        // 2️⃣ Отключаем зум
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = """
            var meta = document.querySelector('meta[name=viewport]');
            if (!meta) {
                meta = document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
            }
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            """
            webView.evaluateJavaScript(js, completionHandler: nil)
        }

        // 3️⃣ Все target="_blank" → в этом же окне
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {

            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
}
