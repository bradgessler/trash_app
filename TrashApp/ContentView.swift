//
//  ContentView.swift
//  TrashApp
//
//  Created by Brad Gessler on 12/30/20.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State var url: String = "https://legiblenews.com/"
    
    var body: some View {
        NavigationView {
            WebViewSheet(url: $url)
        }
    }
}

struct WebViewSheet: View {
    @State var title: String = ""
    @Binding var url: String

    @State var error: Error? = nil
    @State private var hasNavigated = false
    
    func handleNavigation(_ action: WKNavigationAction, _ decision: (WKNavigationActionPolicy) -> Void) -> Void {
        self.url = action.request.url!.absoluteString
        self.hasNavigated = true
        decision(.cancel)
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: WebViewSheet(url: $url), isActive: $hasNavigated) { EmptyView() }
            SwankyWebView(title: $title, url: self.url, navigationChanged: handleNavigation)
        }
        .navigationBarTitle(title, displayMode: .inline)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
