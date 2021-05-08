//
//  Playlist.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import Foundation
import UIKit

struct Playlist: Decodable, Identifiable {
    let id: String
    let name: String
    let images: [ImageResponse]
    let tracks: TrackNr
    var uiImage: UIImage? = nil
    var likes: Int = 0
    var liked: Bool = false

    private enum CodingKeys: String, CodingKey {
        case id, name, images, tracks
    }
}

struct TrackNr: Decodable {
    let total: Int
}
