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
            getTopPlaylists { [weak self] playlists in
                
                for (key, playlist) in playlists.enumerated() {

//                    self?.getPlaylistImage(url: playlist.i) { (image) in
//                        DispatchQueue.main.async {
//                            self?.playlistsBuilder?[key].uiImage = image
//                        }
//                    }
                    
                }
                
                DispatchQueue.main.async {
                    self?.playlists = playlists
                }
            }
        }
        
        func getTopPlaylists(completion: @escaping ([FireStorePlaylist]) -> Void) {
            FireStoreManager.shared.getPlaylistFromDate { result in
                switch result {
                case .success(let playlists):
                    print(playlists.count)
                    completion(playlists)
                case .failure(let error):
                    print(error)
                    completion([])
//                    self?.playlists = nil
                    break
                }
            }
        }
    }
}
