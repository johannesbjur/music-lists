//
//  music_listsApp.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import SwiftUI
import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct music_listsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
