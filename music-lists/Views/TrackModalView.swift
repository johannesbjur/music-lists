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
                        .frame(height: 100)
                    
                    VStack {
                        Image("placeholder_image")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                            .padding(.bottom, 70)
                        
                        Text(track?.name ?? "")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold, design: .default))
                            .padding(.bottom, 15)
                        Text(track?.artists[0].name ?? "")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold, design: .default))
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
