//
//  SearchView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-30.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
