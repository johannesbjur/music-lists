//
//  TrackItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-28.
//

import SwiftUI

struct TrackItemCell: View {

    var track: Track

    var body: some View {
        HStack {
            if let albumImage = track.uiImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            VStack {
                Text(track.name)
                    .foregroundColor(.white)
                Text(track.album.name)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct TrackItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackItemCell()
//    }
//}
