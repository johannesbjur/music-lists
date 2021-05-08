//
//  HomeViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import Foundation
import UIKit
import Firebase

extension HomeView {
    class HomeViewModel: ObservableObject {
        @Published var playlists: [Playlist]? = nil
        var playlistsBuilder: [Playlist]?
        var fireStorePlaylists: [FireStorePlaylist]?
        
        let dispatchGroup = DispatchGroup()

        init() {
            FireStoreManager.shared.signIn()
            
            getSpotifyPlaylists()
            getFireStorePlaylists()
            
            dispatchGroup.notify(queue: .main) {
                guard let playlists = self.playlistsBuilder, let fireStorePlaylists = self.fireStorePlaylists else { return }
                for (index, playlist) in playlists.enumerated() {
                    if !(fireStorePlaylists.contains { $0.playlistId == playlist.id }) {
                        FireStoreManager.shared.createFireStorePlaylist(playlist: playlist)
                    } else {
                        guard let fireIndex = fireStorePlaylists.firstIndex(where: { $0.playlistId == playlist.id }) else { return }
                        self.playlistsBuilder?[index].likes = fireStorePlaylists[fireIndex].likes
//                        TODO: Look over issues with getuiImage
                        self.playlists = self.playlistsBuilder
                    }
                }
            }
        }
        
        private func getFireStorePlaylists() {
            dispatchGroup.enter()
            
            FireStoreManager.shared.getUserPlaylists { [weak self] result in
                switch result {
                case .success(let firePlaylists):
                    self?.fireStorePlaylists = firePlaylists
                    self?.dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }

        private func getSpotifyPlaylists() {
            dispatchGroup.enter()
            
            APICaller.shared.getUserPlaylists { [weak self] result in
                switch result {
                case .success(let playlists):
                    DispatchQueue.main.async {
                        self?.playlistsBuilder = playlists
                        self?.dispatchGroup.leave()
                    }
                    for (key, playlist) in playlists.enumerated() {
                        if playlist.images.count > 0 {
                            self?.getPlaylistImage(url: playlist.images[0].url) { (image) in
                                DispatchQueue.main.async {
                                    self?.playlistsBuilder?[key].uiImage = image
                                }
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.playlistsBuilder = nil
                    }
                    break
                }
            }
        }

        private func getPlaylistImage(url: String, completion: @escaping (UIImage?) -> Void) {
            APICaller.shared.getImage(with: url) { (result) in
                switch result {
                case .success(let imageData):
                    completion(UIImage(data: imageData))
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                    break
                }
            }
        }
    }
}
