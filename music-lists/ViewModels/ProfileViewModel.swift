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
                    self?.getProfileImage(url: (user?.images[0].url)!)
                }
            }
            getTopTracks { [weak self] tracks in
                DispatchQueue.main.async {
                    guard let tracks = tracks else { return }
                    self?.topTracks = tracks
                    for (key, track) in tracks.enumerated() {
                        self?.getTrackImage(url: track.album.images[0].url) { [weak self] (image) in
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

        private func getProfileImage(url: String) {
            APICaller.shared.getImage(with: url) { [weak self] (result) in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        self?.profileImage = UIImage(data: imageData)
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }

        private func getTrackImage(url: String, completion: @escaping (UIImage?) -> Void) {
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
