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
                    guard let sortedPlaylists = self?.bubbleSortPlaylists(playlists: playlists) else { return }
                    DispatchQueue.main.async {
                        self?.playlists = sortedPlaylists
                    }
                    for (key, playlist) in sortedPlaylists.enumerated() {
                        APICaller.shared.getUIImage(url: playlist.imageUrl) { uiImage in
                            DispatchQueue.main.async {
                                self?.playlists?[key].uiImage = uiImage
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
        
        private func bubbleSortPlaylists(playlists: [FireStorePlaylist]) -> [FireStorePlaylist] {
            
            var mutablePlaylists = playlists
            var swap = true

            while(swap) {
                swap = false
                for i in 1..<mutablePlaylists.count {
                    if mutablePlaylists[i-1].likes < mutablePlaylists[i].likes  {
                        let temp = mutablePlaylists[i-1]
                        mutablePlaylists[i-1] = mutablePlaylists[i]
                        mutablePlaylists[i] = temp
                        swap = true
                    }
                }
            }
            return mutablePlaylists
        }
    }
}
