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
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }

                    Text(viewModel.user?.display_name ?? "")
                        .foregroundColor(.white)

                    Text("Your top 5 songs")
                        .foregroundColor(.white)

                    if let tracks = viewModel.topTracks, viewModel.topTracks?.count == 5 {
                        VStack {
                            ForEach(tracks) { track in
                                TrackItemCell(track: track)
                                    .listRowBackground(Color("black"))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
