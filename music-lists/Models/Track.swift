//
//  Track.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation
import UIKit

struct Track: Codable, Identifiable {
    let id: String
    let name: String
    let album: Album
    let artists: [Artist]
    var uiImage: UIImage? = nil

    private enum CodingKeys: String, CodingKey {
        case id, name, album, artists
    }
}

struct Album: Codable {
    let name: String
    let images: [ImageItem]
}

struct Artist: Codable {
    let name: String
}
