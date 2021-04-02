//
//  ProfileViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation
import UIKit

extension ProfileView {
    class ProfileViewModel: ObservableObject {
        @Published var user: UserProfile?
        @Published var topTracks: [Track]?
        @Published var profileImage: UIImage?

        init() {
            getUserData { [weak self] user in
                DispatchQueue.main.async {
                    self?.user = user
//                    TODO: cache image
                    guard let profileImgUrl = user?.images[0].url else { return }
                    APICaller.shared.getUIImage(url: profileImgUrl) { [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.profileImage = image
                        }
                    }
                }
            }
            getTopTracks { [weak self] tracks in
                DispatchQueue.main.async {
                    guard let tracks = tracks else { return }
                    self?.topTracks = tracks
                    for (key, track) in tracks.enumerated() {
                        APICaller.shared.getUIImage(url: track.album.images[0].url) { [weak self] (image) in
                            DispatchQueue.main.async {
                                self?.topTracks?[key].uiImage = image
                            }
                        }
                    }
                }
            }
        }

        private func getUserData(completion: @escaping (UserProfile?) -> Void) {
            APICaller.shared.getCurrentUserProfile { result in
                switch result {
                case .success(let user):
                    completion(user)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                    break
                }
            }
        }

        private func getTopTracks(completion: @escaping ([Track]?) -> Void) {
            APICaller.shared.getUserTopTracks { result in
                switch result {
                case .success(let tracks):
                    completion(tracks)
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
