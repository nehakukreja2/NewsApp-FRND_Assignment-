//
//  WebViewDetailScreen.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
}

struct WebViewContainer: UIViewRepresentable {
    
    @ObservedObject var webViewModel: WebViewModel

    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, webViewModel)
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.webViewModel.url) else {
            return WKWebView()
        }

        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webViewModel.shouldGoBack {
            uiView.goBack()
            webViewModel.shouldGoBack = false
        }
    }
}

extension WebViewContainer {
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        @ObservedObject private var webViewModel: WebViewModel
        private let parent: WebViewContainer

        init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
    }
}

struct WebViewDetailScreen: View {
    @StateObject var webViewModel: WebViewModel
    
    init(url: String) {
        _webViewModel = StateObject(wrappedValue: WebViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            WebViewContainer(webViewModel: webViewModel)
                .ignoresSafeArea()
            
            if webViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    WebViewDetailScreen()
//}
