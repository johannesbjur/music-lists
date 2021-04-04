//
//  PlaylistViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-02.
//

import Foundation
import UIKit

extension PlaylistView {
    class PlaylistViewModel: ObservableObject {
        @Published var tracks: [Track]?
        @Published var playlistImage: UIImage?

        func getPlaylistTracks(playlistId: String) {
            APICaller.shared.getPlaylistTracks(playlistId: playlistId) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    break
                case .success(let result):
                    var tracks = [Track]()
                    for track in result.tracks.items {
                        tracks.append(track.track)
                    }
                    DispatchQueue.main.async {
                        self?.tracks = tracks
                    }
                    APICaller.shared.getUIImage(url: result.images[0].url) { (image) in
                        DispatchQueue.main.async {
                            self?.playlistImage = image
                        }
                    }
                    for (key, track) in tracks.enumerated() {
                        guard track.album.images.count > 0 else { return }
                        APICaller.shared.getUIImage(url: track.album.images[0].url) { [weak self] (image) in
                            DispatchQueue.main.async {
                                self?.tracks?[key].uiImage = image
                            }
                        }
                    }
                    break
                }
            }
        }
    }
}
