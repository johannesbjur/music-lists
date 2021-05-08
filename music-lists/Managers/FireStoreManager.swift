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
                completion(.failure(error!))
                return
            }
            
            var playlists: [FireStorePlaylist] = []
            
            playlists = documents.compactMap { queryDocumentSnapshot -> FireStorePlaylist? in
                let data = queryDocumentSnapshot.data()
                let userId = data["userId"] as? String ?? ""
                let playlistId = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let likes = data["likes"] as? Int ?? 0
                let createdAt = data["createdAt"] as? Date ?? Date()
                return FireStorePlaylist(userId: userId,
                                         playlistId: playlistId,
                                         name: name, likes: likes,
                                         createdAt: createdAt)
            }
            completion(.success(playlists))
        }
    }
    
    func createFireStorePlaylist(playlist: Playlist) {
        guard let userId = userId else { return }
        db.collection("playlists")
            .document(playlist.id)
            .setData([
                        "userId": userId,
                        "name": playlist.name,
                        "likes": 0,
                        "createdAt": Date()
                    ])
    }
    
    func likePlaylist(playlistId: String) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).setData([
            "likedPlaylists": FieldValue.arrayUnion([playlistId])
        ], merge: true)
        
        db.collection("playlists").document(playlistId).updateData([
            "likes": FieldValue.increment(Int64(1))
        ])
    }
    
    func unlikePlaylist(playlistId: String) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).setData([
            "likedPlaylists": FieldValue.arrayRemove([playlistId])
        ], merge: true)
        
        db.collection("playlists").document(playlistId).updateData([
            "likes": FieldValue.increment(Int64(-1))
        ])
    }
    
    func getUserLiked(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let userId = userId else { return }
        db.collection("users").document(userId).getDocument { (document, error) in
            guard let likedPlaylists = document?.data()?["likedPlaylists"] as? [String], error == nil else {
                print(error!)
                completion(.failure(error!))
                return
            }
            completion(.success(likedPlaylists))
        }
    }
}
