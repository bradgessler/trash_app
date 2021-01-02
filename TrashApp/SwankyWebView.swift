// From https://developer.apple.com/forums/thread/126986

import SwiftUI
import WebKit

struct SwankyWebView: UIViewRepresentable {
    @Binding var title: String
    @State var didFinishLoading = false
    var url: String
    
    var loadStatusChanged: ((Bool, Error?) -> Void)? = nil
    var navigationChanged: ((WKNavigationAction, (WKNavigationActionPolicy) -> Void) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> SwankyWebView {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }
    
    func onNavigationChanged(perform: ((WKNavigationAction, (WKNavigationActionPolicy) -> Void) -> Void)?) -> SwankyWebView {
        var copy = self
        copy.navigationChanged = perform
        return copy
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SwankyWebView

        init(_ parent: SwankyWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
            parent.didFinishLoading = true
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
            parent.didFinishLoading = true
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
            guard let navigationChanged = parent.navigationChanged else { return decisionHandler(.allow) }
            
            if parent.didFinishLoading {
                navigationChanged(decidePolicyFor, decisionHandler)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

struct Display: View {
    @State var title: String = ""
    @State var error: Error? = nil

    var body: some View {
        NavigationView {
            SwankyWebView(title: $title, url: "https://www.apple.com/")
                .onLoadStatusChanged { loading, error in
                    if loading {
                        print("Loading started")
                        self.title = "Loading…"
                    }
                    else {
                        print("Done loading.")
                        if let error = error {
                            self.error = error
                            if self.title.isEmpty {
                                self.title = "Error"
                            }
                        }
                        else if self.title.isEmpty {
                            self.title = "Some Place"
                        }
                    }
            }
            .navigationBarTitle(title)
        }
    }
}

struct SwankyWebView_Previews: PreviewProvider {
    static var previews: some View {
        Display()
    }
}
