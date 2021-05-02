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
    
    func getUserPlaylists(completion: @escaping ([FireStorePlaylist]) -> Void) {
        db.collection("playlists").whereField("userId", isEqualTo: userId ?? "").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                completion([])
            }
            guard let documents = snapshot?.documents else {
                print("No documents")
                completion([])
                return
            }
            
            var playlists: [FireStorePlaylist] = []
            
            playlists = documents.compactMap { queryDocumentSnapshot -> FireStorePlaylist? in
                let data = queryDocumentSnapshot.data()
                let userId = data["userId"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let likes = data["likes"] as? Int ?? 0
                let createdAt = data["createdAt"] as? Date ?? Date()
                return FireStorePlaylist(userId: userId, name: name, likes: likes, createdAt: createdAt)
            }

            completion(playlists)
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
}
