//
//  AuthResponse.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import Foundation


struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
