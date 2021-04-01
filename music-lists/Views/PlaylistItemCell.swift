//
//  PlaylistItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-01.
//

import SwiftUI

struct PlaylistItemCell: View {

    var playlist: Playlist

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
                Text("\(playlist.tracks.total)")
                    .foregroundColor(.white)
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
