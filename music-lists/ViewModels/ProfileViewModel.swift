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
        
        private var apiCallerService: APICallerProtocol

        init(apiCallerService: APICallerProtocol = APICaller.shared) {
            self.apiCallerService = apiCallerService
            setupUserData()
            setupTopTracks()
        }

        private func setupUserData() {
            apiCallerService.getCurrentUserProfile { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.user = user
                    }
                    APICaller.shared.getUIImage(url: user.images[0].url) { [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.profileImage = image
                        }
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.user = nil
                    }
                    break
                }
            }
        }

        func setupTopTracks() {
            apiCallerService.getUserTopTracks { [weak self] result in
                switch result {
                case .success(let tracks):
                    DispatchQueue.main.async {
                        self?.topTracks = tracks
                    }
                    for (key, track) in tracks.enumerated() {
                        APICaller.shared.getUIImage(url: track.album.images[0].url) { [weak self] (image) in
                            DispatchQueue.main.async {
                                self?.topTracks?[key].uiImage = image
                            }
                        }
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.topTracks = nil
                    }
                    break
                }
            }
        }
        
        func signOut(authManager: AuthManager) {
            FireStoreManager.shared.signOut()
            authManager.signOut()
        }
    }
}
