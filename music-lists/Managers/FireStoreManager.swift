//
//  FireStoreManager.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-02.
//

import Firebase
import FirebaseFirestore

final class FireStoreManager {
    static let shared = FireStoreManager()
    
    private var db = Firestore.firestore()
    
    private var userId: String? {
        return UserDefaults.standard.string(forKey: "firestore_uid")
    }
    
    func signIn() {
//        Auth.auth().signIn(withCustomToken: <#T##String#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
        Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user else { return }
            UserDefaults.standard.setValue(user.uid, forKey: "firestore_uid")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func getUserPlaylists(completion: @escaping (Result<[FireStorePlaylist], Error>) -> Void) {
        db.collection("playlists").whereField("userId", isEqualTo: userId ?? "").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("No documents")
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            var playlists: [FireStorePlaylist] = []
            
            playlists = documents.compactMap { queryDocumentSnapshot -> FireStorePlaylist? in
                let data = queryDocumentSnapshot.data()
                return FireStorePlaylist(dictionary: data, id: queryDocumentSnapshot.documentID)
            }
            completion(.success(playlists))
        }
    }
    
    func createFireStorePlaylist(playlist: Playlist) {
        guard let userId = userId else { return }
        let imgUrl = playlist.images.indices.contains(0) ? playlist.images[0].url : ""
        db.collection("playlists")
            .document(playlist.id)
            .setData([
                        "userId": userId,
                        "name": playlist.name,
                        "likes": 0,
                        "imageUrl": imgUrl,
                        "createdAt": Date(),
                        "tracks": playlist.tracks.total
                    ])
    }
    
    func likePlaylist(playlistId: String) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if document?.data()?["likedPlaylists"] as? [String] == nil {
                self.likePlaylist(playlistId: playlistId, userId: userId)
            }
            if let likedPlaylists = document?.data()?["likedPlaylists"] as? [String],
               !likedPlaylists.contains(playlistId) {
                self.likePlaylist(playlistId: playlistId, userId: userId)
            }
        }
    }
    
    private func likePlaylist(playlistId: String, userId: String) {
        self.db.collection("users").document(userId).setData([
            "likedPlaylists": FieldValue.arrayUnion([playlistId])
        ], merge: true)
        
        self.db.collection("playlists").document(playlistId).updateData([
            "likes": FieldValue.increment(Int64(1))
        ])
    }
    
    func unlikePlaylist(playlistId: String) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { (document, error) in
            guard let likedPlaylists = document?.data()?["likedPlaylists"] as? [String], error == nil else {
                print(error!)
                return
            }
            if likedPlaylists.contains(playlistId) {
                self.db.collection("users").document(userId).setData([
                    "likedPlaylists": FieldValue.arrayRemove([playlistId])
                ], merge: true)
                
                self.db.collection("playlists").document(playlistId).updateData([
                    "likes": FieldValue.increment(Int64(-1))
                ])
            }
        }
    }
    
    func getUserLiked(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { (document, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            if let likedPlaylists = document?.data()?["likedPlaylists"] as? [String] {
                completion(.success(likedPlaylists))
            } else {
                completion(.success([]))
            }  
        }
    }
    
    func getPlaylistFromDate(completion: @escaping (Result<[FireStorePlaylist], Error>) -> Void) {
//        Get playlists from last 7 days
        let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        db.collection("playlists").whereField("createdAt", isGreaterThan: date).getDocuments { (snapshots, error) in
            guard let documents = snapshots?.documents, error == nil else {
                print(error!)
                completion(.failure(error!))
                return
            }
            
            var playlists: [FireStorePlaylist] = []
            
            playlists = documents.compactMap { queryDocumentSnapshot -> FireStorePlaylist? in
                let data = queryDocumentSnapshot.data()
                return FireStorePlaylist(dictionary: data, id: queryDocumentSnapshot.documentID)
            }
            completion(.success(playlists))
        }
    }
}
