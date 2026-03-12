import SwiftUI
import WebKit

/// Wrapper mínimo de WKWebView para lookup web futuro.
struct VehicleLookupWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
