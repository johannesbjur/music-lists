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
        var likedPlaylists: [String]?
        
        let dispatchGroup = DispatchGroup()

        init() {
            FireStoreManager.shared.signIn()
            
            getSpotifyPlaylists()
            getFireStorePlaylists()
            getLikedPlaylists()
            
            dispatchGroup.notify(queue: .main) {
//                TODO: refactor
                guard let playlists = self.playlistsBuilder else { return }
                for (index, playlist) in playlists.enumerated() {
                    if let likedPlaylists = self.likedPlaylists, likedPlaylists.contains(where: { $0 == playlist.id }) {
                        self.playlistsBuilder?[index].liked = true
                    }
                    if let fireStorePlaylists = self.fireStorePlaylists, !(fireStorePlaylists.contains { $0.playlistId == playlist.id }) {
                        FireStoreManager.shared.createFireStorePlaylist(playlist: playlist)
                    } else if let fireStorePlaylists = self.fireStorePlaylists {
                        guard let fireIndex = fireStorePlaylists.firstIndex(where: { $0.playlistId == playlist.id }) else { return }
                        self.playlistsBuilder?[index].likes = fireStorePlaylists[fireIndex].likes
                    }
                    DispatchQueue.main.async {
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
                    self?.dispatchGroup.leave()
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
                    self?.dispatchGroup.leave()
                    break
                case .failure(let error):
                    print(error)
                    self?.playlistsBuilder = nil
                    self?.dispatchGroup.leave()
                    break
                }
            }
        }
        
        private func getLikedPlaylists() {
            dispatchGroup.enter()
            
            FireStoreManager.shared.getUserLiked { [weak self] result in
                switch result {
                case .success(let likedPlaylists):
                    self?.likedPlaylists = likedPlaylists
                    self?.dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                    self?.likedPlaylists = nil
                    self?.dispatchGroup.leave()
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
