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
    var liked: Bool = false
    let tracks: Int
    
    private enum CodingKeys: String, CodingKey {
        case userId, playlistId, name, likes, createdAt, imageUrl, tracks
    }
}

extension FireStorePlaylist {
    init(dictionary: [String: Any], id: String) {
        self.playlistId = id
        self.userId = dictionary["userId"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.tracks = dictionary["tracks"] as? Int ?? 0        
    }
}
