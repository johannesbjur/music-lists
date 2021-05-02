//
//  FireStorePlaylist.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-02.
//

import Foundation

struct FireStorePlaylist: Codable {
    let userId: String
    let playlistId: String
    let name: String
    let likes: Int
    let createdAt: Date
}
