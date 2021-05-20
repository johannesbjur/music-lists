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
                    
                    for (key, playlist) in playlists.enumerated() {
                        if playlist.images.count > 0 {
                            APICaller.shared.getUIImage(url: playlist.images[0].url) { image in
                                DispatchQueue.main.async {
                                    self?.playlists?[key].uiImage = image
                                }
                            }
                        }
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
