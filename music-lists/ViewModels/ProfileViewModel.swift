//
//  ProfileViewModel.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation

extension ProfileView {
    class ViewModel: ObservableObject {
        @Published var user: UserProfile?
        @Published var topTracks: [Track]?

        init() {
            getUserData { user in
                DispatchQueue.main.async {
                    self.user = user
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
    }
}
