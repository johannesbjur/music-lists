//
//  ProfileView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct ProfileView: View {

    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("black"))
    }

    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack{
                        Spacer()
                        Button {
                            print("signout")
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .padding(.trailing, 40)
                                .padding(.top, 10)
                        }
                    }
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }

                    Text(viewModel.user?.display_name ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .padding()

                    Text("Your top 5 songs")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .padding()
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let tracks = viewModel.topTracks, viewModel.topTracks?.count == 5 {
                        VStack {
                            ForEach(tracks.indices) { i in
                                HStack {
                                    Text("\(i+1).")
                                        .foregroundColor(.white)
                                        .padding(.leading, 30)
                                        .padding(.bottom, 15)
                                        
                                    TrackItemCell(track: tracks[i])
                                        .listRowBackground(Color("black"))
                                        .padding(.bottom, 15)
                                        .padding(.trailing, 15)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
