//
//  AddToPlaylistView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-09.
//

import SwiftUI

struct AddToPlaylistView: View {
    @StateObject var viewModel = AddToPlaylistViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let trackId: String?
    
    var body: some View {
        ZStack {
            Color("black")
            VStack {
                Spacer()
                    .frame(height: 150)
                if let playlists = viewModel.playlists {
                    ScrollView {
                        ForEach(playlists) { playlist in
                            Button {
                                guard let trackId = trackId else { return }
                                presentationMode.wrappedValue.dismiss()
                                viewModel.addToPlaylist(trackId: trackId, playlistId: playlist.id)
                            } label: {
                                HStack {
                                    if let uiImage = playlist.uiImage {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image("placeholder_image")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    HStack {
                                        VStack {
                                            Text(playlist.name)
                                                .foregroundColor(.white)
                                                .bold()
                                                .lineLimit(2)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("\(playlist.tracks.total) Tracks")
                                                .foregroundColor(.gray)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Add track to playlist")
        .edgesIgnoringSafeArea(.all)
    }
}

//struct AddToPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToPlaylistView("")
//    }
//}
