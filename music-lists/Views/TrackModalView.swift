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
        NavigationView {
            ZStack {
                Color("black")
                VStack {
                    Spacer()
                        .frame(height: 50)
                    HStack {
                    Spacer()
                        Button {
                            withAnimation {
                                modalShowing = false
                            }

                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    Text(track?.name ?? "")
                        .foregroundColor(.white)
                    Text(track?.artists[0].name ?? "")
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    
                    NavigationLink(destination: AddToPlaylistView(trackId: track?.id)) {
                        VStack {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                Text("Add to playlist")
                                    .foregroundColor(.white)
                            }
                            Rectangle()
                                .fill(Color.white)
                                .frame(minWidth: 225, idealWidth: 225, maxWidth: 225, minHeight: 2, idealHeight: 2, maxHeight: 2, alignment: .center)
                        }
                    }
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
        .accentColor(.white)
        .offset(x: 0, y: self.modalShowing ? 0 : UIScreen.main.bounds.size.height )
    }
}

//struct TrackModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackModalView()
//    }
//}
