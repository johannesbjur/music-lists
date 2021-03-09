//
//  ContentView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-08.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
