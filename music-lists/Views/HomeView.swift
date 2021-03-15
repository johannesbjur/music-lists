//
//  HomeView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            Text("Home")
                .foregroundColor(.white)

        }
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
