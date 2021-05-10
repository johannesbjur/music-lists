//
//  FlowViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-08.
//

import Foundation
import UIKit

extension FlowView {
    class FlowViewModel: ObservableObject {
        @Published var playlists: [FireStorePlaylist]?
        var likedPlaylists: [String]?
        
        let dispatchGroup = DispatchGroup()
        
        func setup() {
            getTopPlaylists()
            getLikedPlaylists()
            
            dispatchGroup.notify(queue: .main) {
                guard let playlists = self.playlists else { return }
                for (index, playlist) in playlists.enumerated() {
                    if let likedPlaylists = self.likedPlaylists, likedPlaylists.contains(where: { $0 == playlist.playlistId }) {
                        self.playlists?[index].liked = true
                    }
                }
            }
        }
        
        private func getTopPlaylists() {
            dispatchGroup.enter()
            
            FireStoreManager.shared.getPlaylistFromDate { [weak self] result in
                switch result {
                case .success(let playlists):
                    DispatchQueue.main.async {
                        self?.playlists = playlists
                    }
                    for (key, playlist) in playlists.enumerated() {
                        APICaller.shared.getImage(with: playlist.imageUrl) { [weak self] result in
                            switch result {
                            case .success(let imageData):
                                DispatchQueue.main.async {
                                    self?.playlists?[key].uiImage = UIImage(data: imageData)
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                    self?.dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                    self?.playlists = []
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
    }
}
