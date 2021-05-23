//
//  APICaller.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation
import UIKit

protocol APICallerProtocol {
    func getUserTopTracks(completion: @escaping (Result<[Track], Error>) -> Void)
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
}

final class APICaller: APICallerProtocol {
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
        case playlist = "/playlists/"
        case searchTracks = "/search?type=track&limit=10&q="
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

    func getUIImage(url: String, completion: @escaping (UIImage?) -> Void) {
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

    public func getUserTopTracks(completion: @escaping (Result<[Track], Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.tracks.rawValue), method: .GET) { (baseRequest) in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(TracksResponseBody.self, from: data)
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
                    completion(.success(result.items))
                }
                catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

    func getPlaylistTracks(playlistId: String, completion: @escaping (Result<PlaylistResponseBody, Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.playlist.rawValue + playlistId), method: .GET) { (baseRequest) in
            URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(PlaylistResponseBody.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func addTrackToPlaylist(trackId: String, playlistId: String) {
        let url = URL(string: Constants.baseAPIUrl + "/playlists/\(playlistId)/tracks?uris=spotify%3Atrack%3A" + trackId)
        createAuthRequest(with: url, method: .POST) { (baseRequest) in
            URLSession.shared.dataTask(with: baseRequest).resume()
        }
    }

    func searchTracks(with string: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        createAuthRequest(with: URL(string: Constants.baseAPIUrl + path.searchTracks.rawValue + string), method: .GET) { (baseRequest) in
            URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResponseBody.self, from: data)
                    print(result)

                    completion(.success(result.tracks.items))
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

    struct PlaylistResponseBody: Decodable {
        let images: [ImageResponse]
        let tracks: TracksShell
    }

    struct TracksShell: Decodable {
        let items: [TrackContainer]
    }

    struct TrackContainer: Decodable {
        let track: Track
    }

    struct SearchResponseBody: Decodable {
        let tracks: TracksResponseBody
    }
}
