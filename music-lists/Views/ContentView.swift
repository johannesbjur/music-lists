//
//  ContentView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-08.
//

import SwiftUI

struct ContentView: View {

    @StateObject var authManager = AuthManager()

    var body: some View {
        ZStack {
            if !authManager.isSignedIn {
                NavigationView {
                    LoginView()
                }
            }
            else {
                MainTabView()
            }
        }
        .environmentObject(authManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
