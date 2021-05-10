//
//  FlowPlaylistItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-05-10.
//

import SwiftUI

struct FlowPlaylistItemCell: View {
    let playlist: FireStorePlaylist
    
    var body: some View {
        HStack {
            if let uiImage = playlist.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                Image("placeholder_image")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            HStack {
                VStack {
                    Text(playlist.name)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(playlist.tracks.description) Tracks")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 20)
                HStack {
                    if playlist.liked {
                        Text(playlist.likes.description)
                            .bold()
                            .foregroundColor(.white)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                    } else {
                        Text(playlist.likes.description)
                            .bold()
                            .foregroundColor(.gray)
                        Image(systemName: "heart")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct FlowPlaylistItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowPlaylistItemCell()
//    }
//}
