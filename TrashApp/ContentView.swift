//
//  ContentView.swift
//  TrashApp
//
//  Created by Brad Gessler on 12/30/20.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State var title: String = ""
    @State var error: Error? = nil

    var body: some View {
        NavigationView {
            SwankyWebView(title: $title, url: URL(string: "https://www.apple.com/")!)
                .onNavigationChanged { navigationAction, decisionHandler in
                    self.title = navigationAction.request.url?.absoluteString ?? "Har har har"
                    decisionHandler(.cancel)
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView: View {
    @State var url: String

    var body: some View {
        SimpleWebView(url: self.url)
        NavigationLink(destination: WebView(url: "https://www.yahoo.com/")) {
            Text("Load next page")
        }.navigationBarTitle("Navigation")
    }
}
