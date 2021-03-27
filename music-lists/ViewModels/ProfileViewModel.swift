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

        init() {
            getUserData { user in
                self.user = user
            }
        }

        func getUserData(completion: @escaping (UserProfile?) -> Void) {
            APICaller.shared.getCurrentUserProfile { result in
                switch result {
                case .success(let user):
                    print(user)
                    completion(user)
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
