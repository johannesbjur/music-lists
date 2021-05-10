//
//  PlaylistItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import SwiftUI

struct PlaylistItemCell: View {

    var playlist: Playlist
    let hide: Bool = false
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
            } else {
                Image("placeholder_image")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            HStack {
                VStack {
                    Text(playlist.name)
                        .foregroundColor(.white)
                        .bold()
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(playlist.tracks.total) Tracks")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 15)
                HStack {
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
                        if liked {
                            Text("\(likeCount)")
                                .foregroundColor(.white)
                                .bold()
                            Image(systemName: "heart.fill").foregroundColor(.white)
                        } else {
                            Text("\(likeCount)")
                                .foregroundColor(.gray)
                                .bold()
                            Image(systemName: "heart").foregroundColor(.gray)
                        }
                    }
                }
                .padding(.trailing, 20)
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
