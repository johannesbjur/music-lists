//
//  SearchViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-03.
//

import Foundation

extension SearchView {
    class SearchViewModel: ObservableObject {
        @Published var searchedTracks: [Track]?

        func searchTracks(with string: String) {
            APICaller.shared.searchTracks(with: string) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.searchedTracks = nil
                    }
                    break
                case .success(let tracks):
                    DispatchQueue.main.async {
                        self?.searchedTracks = tracks
                    }
                    for (key, track) in tracks.enumerated() {
                        APICaller.shared.getUIImage(url: track.album.images[0].url) { [weak self] (image) in
                            DispatchQueue.main.async {
                                self?.searchedTracks?[key].uiImage = image
                            }
                        }
                    }
                    break
                }
            }
        }
    }
}
