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
            

            VStack {
                Text(track.name)
                Text(track.album.name)
            }
        }

    }
}

//struct TrackItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackItemCell(track: Track(id: "123", album: Album(name: "Album"), name: "name"))
//    }
//}
