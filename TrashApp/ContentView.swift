//
//  ContentView.swift
//  TrashApp
//
//  Created by Brad Gessler on 12/30/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ExtractedView(url: "https://www.google.com/")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ExtractedView: View {
    @State var url: String

    var body: some View {
        SimpleWebView(url: self.url)
        NavigationLink(destination: ExtractedView(url: "https://www.yahoo.com/")) {
            Text("Load next page")
        }.navigationBarTitle("Navigation")
    }
}
