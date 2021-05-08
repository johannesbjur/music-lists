//
//  FlowViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-08.
//

import Foundation

extension FlowView {
    class FlowViewModel: ObservableObject {
        @Published var playlists: [FireStorePlaylist]?
        
        init() {
            FireStoreManager.shared.getPlaylistFromDate { [weak self] result in
                switch result {
                case .success(let playlists):
                    print(playlists.count)
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
    }
}
