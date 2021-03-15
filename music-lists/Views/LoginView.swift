//
//  LoginView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-09.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
            VStack {
                Text("Login")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding()
                
                NavigationLink(
                    destination: AuthWebView()
                ) {
                    Text("Sign in with Spotify")
                        .frame(width: 280, height: 50)
                        .background(Color("green"))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
