//
//  AddToPlaylistViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-09.
//

import Foundation

extension AddToPlaylistView {
    class AddToPlaylistViewModel: ObservableObject {
        @Published var playlists: [Playlist]?
        
        init() {
            getUserPlaylists()
        }
        
        func getUserPlaylists() {
            APICaller.shared.getUserPlaylists { [weak self] result in
                switch result {
                case .success(let playlists):
                    DispatchQueue.main.async {
                        self?.playlists = playlists
                    }
                case .failure(let error):
                print(error)
                self?.playlists = nil
                break
                }
            }
        }
        
        func addToPlaylist(trackId: String, playlistId: String) {
            APICaller.shared.addTrackToPlaylist(trackId: trackId, playlistId: playlistId)
        }
    }
}
