//
//  PlaylistItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import SwiftUI

struct PlaylistItemCell: View {

    var playlist: Playlist
    @State var likeCount: Int
    @State var liked: Bool
    
    init(playlist: Playlist) {
        self.playlist = playlist
        _likeCount = State(initialValue: playlist.likes)
        _liked = State(initialValue: playlist.liked)
    }
    
    var body: some View {
        HStack {
            if let uiImage = playlist.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            VStack {
                Text(playlist.name)
                    .foregroundColor(.white)
                    .lineLimit(2)
                HStack {
                    Text("\(playlist.tracks.total)")
                        .foregroundColor(.white)
                    
                    Button {
                        liked.toggle()
                        if liked {
                            likeCount = likeCount + 1
                            FireStoreManager.shared.likePlaylist(playlistId: playlist.id)
                        } else {
                            likeCount = likeCount - 1
                            FireStoreManager.shared.unlikePlaylist(playlistId: playlist.id)
                        }
                    } label: {
                        liked ? Image(systemName: "heart.fill").foregroundColor(.white)
                              : Image(systemName: "heart").foregroundColor(.gray)
                              
                    }

                    Text("\(likeCount)")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct PlaylistItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistItemCell()
//    }
//}
