//
//  MockAPICaller.swift
//  music-listsTests
//
//  Created by Johannes Bjurströmer on 2021-05-17.
//

@testable import music_lists

final class MockAPICaller: APICallerProtocol {
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let userProfile = UserProfile(country: "se", id: "123", display_name: "testName", images: [ImageResponse(url: "url")], product: "test")
        completion(.success(userProfile))
    }
    
    func getUserTopTracks(completion: @escaping (Result<[Track], Error>) -> Void) {
        let tracks = [
            Track(id: "123", name: "testName", album: Album(name: "testAlbum", images: [ImageResponse(url: "url")]), artists: [Artist(name: "testArtist")])
        ]
        completion(.success(tracks))
    }
}
