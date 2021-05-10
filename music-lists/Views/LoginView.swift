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
                Wave()
                    .fill(Color("green"))
                    .frame(height: 180)
                
                Spacer()
                    .frame(height: 180)
                
                Text("Login")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                    .frame(height: 30)
                
                NavigationLink(
                    destination: AuthWebView()
                ) {
                    HStack {
                        Image("spotify_icon_white")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text("Sign in with Spotify")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .frame(width: 260, height: 55)
                    .background(Color("green"))
                    .cornerRadius(30)
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX*2, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY*1.5),
                      control1: CGPoint(x: rect.maxX * 0.3, y: rect.midY),
                      control2: CGPoint(x: rect.maxX * 0.7, y: rect.maxY * 1.7))
        path.closeSubpath()
        
        return path
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
