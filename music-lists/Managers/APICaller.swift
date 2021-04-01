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

    enum path: String {
        case user = "/me"
        case tracks = "/me/top/tracks?limit=5"
        case playlists = "/me/playlists"
    }

    private init() {}

    private func createAuthRequest(with url: URL?, method: HTTPMethod, completion: @escaping (URLRequest) -> Void){
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

// MARK:- Fetch functions
extension APICaller {
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.user.rawValue), method: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
//                    print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    func getImage(with url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }

    public func getUserTopTracks(completion: @escaping (Result<[Track], Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.tracks.rawValue), method: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(TracksResponseBody.self, from: data)
//                    print(result)
                    completion(.success(result.items))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    func getUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.playlists.rawValue), method: .GET) { (baseRequest) in
            URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistsResponseBody.self, from: data)
//                    print(result)
                    completion(.success(result.items))
                }
                catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}

extension APICaller {
    struct TracksResponseBody: Decodable {
        let items: [Track]
    }

    struct PlaylistsResponseBody: Decodable {
        let items: [Playlist]
    }
}
