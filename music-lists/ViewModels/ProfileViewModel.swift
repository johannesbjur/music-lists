//
//  ProfileViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation
import UIKit

extension ProfileView {
    class ViewModel: ObservableObject {
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
            getTopTracks { tracks in
                DispatchQueue.main.async {
                    self.topTracks = tracks
                }
            }
        }

        func getUserData(completion: @escaping (UserProfile?) -> Void) {
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

        func getTopTracks(completion: @escaping ([Track]?) -> Void) {
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

        func getProfileImage(url: String) {
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
    }
}
