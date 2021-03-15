//
//  ProfileView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-13.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            Text("Profile")
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
