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
                                Text(playlist.name)
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct AddToPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToPlaylistView("")
//    }
//}
