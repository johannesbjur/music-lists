//
//  APICaller.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation


final class APICaller {
    static let shared = APICaller()

    enum HTTPMethod: String {
        case GET
        case POST
    }

    enum APIError: Error {
        case failedToGetData
    }

    struct Constants {
        static let baseAPIUrl = "https://api.spotify.com/v1"
    }

    private init() {}

    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIUrl + "/me"), method: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { (data, _, error) in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    private func createRequest(with url: URL?, method: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        guard let url = url else { return }
        AuthManager.shared.withValidToken { (token) in
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = method.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
