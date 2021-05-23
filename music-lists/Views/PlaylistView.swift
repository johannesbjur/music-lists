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
                Spacer()
                    .frame(height: 120)
                if let playlistImage = viewModel.playlistImage {
                    Image(uiImage: playlistImage)
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                } else {
                    Image("placeholder_image")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                }
                Text(playlistName)
                    .foregroundColor(.white)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding()
                if let tracks = viewModel.tracks {
                    ForEach(tracks) { track in
                        TrackItemCell(track: track)
                            .padding(.top, 15)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .onAppear {
            viewModel.getPlaylistTracks(playlistId: playlistId)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct PlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistView()
//    }
//}
