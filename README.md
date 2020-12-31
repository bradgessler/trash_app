# TrashApp

Learning SwiftUI by trying to build out a `WebView("https://www.google.com/")` view component that I can plugin into the built-in SwiftUI `NavigationView`. The closest component I could find that does this is https://github.com/kylehickinson/SwiftUI-WebView, but it navigates within WKWebView. I want a component with less state then that; specifically I want it such that when a link is clicked on my `WebView` component, it doesn't actually navigate to the new URL. Instead the state of the `WebView` component should trigger a URL change that can be picked up by SwiftUI and acted upon. For this particular project, when a user clicks on a link, I want to push a new `WebView` component into the `NavigationView` stack.

This repo doesn't quite do that yet. If you watch [this movie](https://s3.amazonaws.com/bradgessler/JXaUDf9aM9Kz5UqVwjMKkSgE4fdhIUWwkw781p1Oe4Vhio4W3gDKpdiiB9j2xZLjAFGrXvckwMY0ji82QKSmXoG0PtZ1BftrnOX1.mov) you'll see when I click on the "Load next page" button, the `NavigationView` controller is used. When I click on a link, its not used. I'd like to intercept these clicks to push the new view onto the `NavigationView` stack.

The goal *after* this excercise is to learn how SwiftUI and WKWebKit work together to make a powerful MIT licenses SwiftUI `WebView` component that others may use in their projects (sadly https://github.com/kylehickinson/SwiftUI-WebView is not MIT licenses, and the maintainer hasn't responded to the ticket to release it under such a license).

I'm new to Swift and SwiftUI, so I'm using this repo to learn more about how Swift, SwiftUI, UIKit, and the WKWebView APIs play together. Relevant to this project, I'm trying to figure out how to put all of this together:

* https://www.hackingwithswift.com/books/ios-swiftui/using-coordinators-to-manage-swiftui-view-controllers
* https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
* https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview
* https://github.com/kylehickinson/SwiftUI-WebView

When it's all said and done, I'd like to put together something that looks like:

```swift
// This could won't work; I'm not sure it's even properly structured.
import SwiftUI
import WebView

struct ContentView: View {
    // Still not confident if this is the way to manage this state.
    @State var hasNavigated = false
    @State var url = ""

    var body: some View {
        NavigationView {
            // The idea her is when the person clicks on a link on `https://www.google.com/`, I want to
            // intercept that event from WKWebView and instead change the state of the SwiftUI view so that
            // NavigationLink can manage the history via the stack.
            NavigationLink(destination: WebView(url: $url), isActive: $isShowingDetailView) { EmptyView() }
            WebView(url: "https://www.google.com/") { navigation in
              // I doubt this works ...
              self.hasNavigated = true
              self.url = navigation.url
            }
        }
    }
}

```