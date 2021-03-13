//
//  music_listsApp.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import SwiftUI

@main
struct music_listsApp: App {

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
