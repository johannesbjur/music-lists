//
//  TracksManager.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-24.
//

import Foundation

final class TracksManager {

    let baseURLString = "https://accounts.spotify.com"

    public var userTopTracksUrl: URL? {
        let base = "\(baseURLString)"
        let path = "/v1/me/top/tracks"
        return URL(string: base + path)
    }

    func fetchUserTopTracks() {
        guard let url = userTopTracksUrl else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        let header =  ["Accept":"application/json",
//                       "Content-Type":"application/json",
//                       "Authorization":"Bearer \(acess_token)"]

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else { return }
//            print("data")
//            print(data.base64EncodedString())

            do {
                let result = try JSONDecoder().decode(ResponseBody.self, from: data)

                print(result.items[0].name)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension TracksManager {

    struct ResponseBody: Decodable {
        let items: [Item]
    }

    struct Item: Decodable {
        let id: String
        let description: String
        let album: Album
        let name: String

    }

    struct Album: Decodable {
        let name: String
    }
}
