//
//  Track.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation

struct Track: Decodable {
    let id: String
    let album: Album
    let name: String

}
struct Album: Decodable {
    let name: String
}
