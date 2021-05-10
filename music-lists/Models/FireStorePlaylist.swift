//
//  FireStorePlaylist.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-02.
//

import Foundation
import UIKit

struct FireStorePlaylist: Codable {
    let userId: String
    let playlistId: String
    let name: String
    let likes: Int
    let createdAt: Date
    let imageUrl: String
    var uiImage: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case userId, playlistId, name, likes, createdAt, imageUrl
    }
}
