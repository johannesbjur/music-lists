//
//  Track.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation

struct Track: Codable, Identifiable {
    let id: String
    let name: String
    let album: Album
    let artists: [Artist]
}

struct Album: Codable {
    let name: String
    let images: [ImageItem]
}

struct Artist: Codable {
    let name: String
}
