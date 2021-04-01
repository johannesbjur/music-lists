//
//  UserProfile.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-27.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let id: String
    let display_name: String
    let images: [ImageResponse]
    let product: String
}
