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
        @Published var playlists: [Playlist]?

        init() {
            FireStoreManager.shared.signIn()
            setupUserPlaylists()
        }

        private func setupUserPlaylists() {
            APICaller.shared.getUserPlaylists { [weak self] result in
                switch result {
                case .success(let playlists):
                    DispatchQueue.main.async {
                        self?.playlists = playlists
                    }
                    for (key, playlist) in playlists.enumerated() {
                        if playlist.images.count > 0 {
                            self?.getPlaylistImage(url: playlist.images[0].url) { (image) in
                                DispatchQueue.main.async {
                                    self?.playlists?[key].uiImage = image
                                }
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.playlists = nil
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
