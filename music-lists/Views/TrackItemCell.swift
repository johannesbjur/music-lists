//
//  TrackItemCell.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-28.
//

import SwiftUI

struct TrackItemCell: View {

    var track: Track
    @EnvironmentObject var modalStatus: TrackModalHandler

    var body: some View {
        HStack {
            if let albumImage = track.uiImage {
                Image(uiImage: albumImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.horizontal)
            }
            VStack {
                Text(track.name)
                    .foregroundColor(.white)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(track.artists[0].name ?? "")
                    .foregroundColor(.gray)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                withAnimation {
                    self.modalStatus.showing = true
                    self.modalStatus.track = track
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

//struct TrackItemCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackItemCell()
//    }
//}
