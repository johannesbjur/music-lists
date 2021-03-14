//
//  AuthView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import SwiftUI
import WebKit

struct AuthWebView: UIViewRepresentable {

    @State var shouldDismiss = false
    let url = AuthManager.shared.signInURL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard !shouldDismiss || !context.environment.presentationMode.wrappedValue.isPresented
        else {
            context.environment.presentationMode.wrappedValue.dismiss()
            return
        }
        guard let url = url else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: AuthWebView

        init(_ uiWebView: AuthWebView) {
            self.parent = uiWebView
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard let url = webView.url else { return }

            let component = URLComponents(string: url.absoluteString)
            guard let code = component?.queryItems?.first(where: { $0.name == "code"})?.value else { return }
            webView.isHidden = true

            AuthManager.shared.exangeCodeForToken(code: code) { success in
                print("Login success: \(success)")
                self.parent.shouldDismiss = true
            }
        }
    }
}
