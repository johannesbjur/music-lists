//
//  PlaylistView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-02.
//

import SwiftUI

struct PlaylistView: View {
    @StateObject var viewModel = PlaylistViewModel()

    let playlistId: String
    let playlistName: String

    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            ScrollView {
                if let playlistImage = viewModel.playlistImage {
                    Image(uiImage: playlistImage)
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                }
                Text(playlistName)
                    .foregroundColor(.white)
                if let tracks = viewModel.tracks {
                    ForEach(tracks) { track in
                        TrackItemCell(track: track)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getPlaylistTracks(playlistId: playlistId)
        }
    }
}

//struct PlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistView()
//    }
//}
