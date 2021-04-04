//
//  TrackModalView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-04-04.
//

import SwiftUI

struct TrackModalView: View {
    @Binding var modalShowing: Bool
    @Binding var track: Track?

    var body: some View {
        ZStack {
            Color("green")
            Text(track?.name ?? "")
            Button {
                withAnimation {
                    modalShowing = false
                }

            } label: {
                Text("Dissmiss")
            }
        }
        .edgesIgnoringSafeArea(.all)
        .offset(x: 0, y: self.modalShowing ? 0 : UIScreen.main.bounds.size.height )
    }
}

//struct TrackModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackModalView()
//    }
//}
