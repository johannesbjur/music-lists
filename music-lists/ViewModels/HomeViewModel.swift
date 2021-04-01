//
//  HomeViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import Foundation
import UIKit

extension HomeView {
    class HomeViewModel: ObservableObject {
        @Published var playlists: [Playlist]?

        init() {
            self.getUserPlaylists { [weak self] (playlists) in
                DispatchQueue.main.async {
                    guard let playlists = playlists else { return }
                    self?.playlists = playlists
                    for (key, playlist) in playlists.enumerated() {
                        if playlist.images.count > 0 {
                            self?.getPlaylistImage(url: playlist.images[0].url) { (image) in
                                DispatchQueue.main.async {
                                    self?.playlists?[key].uiImage = image
                                }
                            }
                        }
                    }
                }
            }
        }

        private func getUserPlaylists(completion: @escaping ([Playlist]?) -> Void) {
            APICaller.shared.getUserPlaylists { result in
                switch result {
                case .failure(let error):
                    print(error)
                    completion(nil)
                    break
                case .success(let playlists):
                    completion(playlists)
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
