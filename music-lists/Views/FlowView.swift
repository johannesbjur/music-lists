//
//  FlowView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-08.
//

import SwiftUI

struct FlowView: View {
    @StateObject var viewModel = FlowViewModel()
    
    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            
            if let playlists = viewModel.playlists {
                ScrollView {
                    ForEach(playlists, id: \.name) { playlist in
                        FlowPlaylistItemCell(playlist: playlist)
                            .padding(.top, 20)
                            .padding(.horizontal, 30)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setup()
        }
        .navigationTitle("Top Playlists")
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView()
    }
}
