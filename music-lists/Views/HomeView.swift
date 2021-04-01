//
//  HomeView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()

            if let playlists = viewModel.playlists {
                ScrollView {
                    ForEach(playlists) { playlist in
                        PlaylistItemCell(playlist: playlist)
                    }
                }
            }
        }
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
