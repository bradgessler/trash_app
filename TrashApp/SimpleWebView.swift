//
//  WebView.swift
//  Thingybase
//
//  Created by Brad Gessler on 12/23/20.
//

import SwiftUI
import UIKit
import WebKit

struct SimpleWebView: UIViewRepresentable {
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent : SimpleWebView
        
        init (_ parent: SimpleWebView, _ webView: WKWebView) {
            self.parent = parent
            super.init()
            webView.navigationDelegate = self
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.navigation = navigation
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, webView)
    }
    
    @State var url: String
    @State var navigation: WKNavigation?
    let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let reqeustURL = URL(string: url) {
        let request = URLRequest(url: reqeustURL)
        webView.load(request)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleWebView(url: "https://www.thingybase.com/")
    }
}
