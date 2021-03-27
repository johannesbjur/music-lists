//
//  ProfileView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct ProfileView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            Text(viewModel.user?.display_name ?? "")
                .foregroundColor(.white)
        }
        .navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
