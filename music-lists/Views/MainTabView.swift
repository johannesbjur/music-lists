//
//  TabView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct MainTabView: View {

    init() {
        UITabBar.appearance().barTintColor = UIColor.init(Color("darkGrey"))
    }

    @StateObject var modalHandler = TrackModalHandler()

    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            NavigationView {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }

            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .environmentObject(modalHandler)
        .accentColor(.white)

        TrackModalView(modalShowing: $modalHandler.showing, track: $modalHandler.track)

    }
}

class TrackModalHandler: ObservableObject {
    @Published var showing = false
    @Published var track: Track?
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
