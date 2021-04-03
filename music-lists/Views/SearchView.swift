//
//  SearchView.swift
//  music-lists
//
//  Created by Johannes Bjurströmer on 2021-03-30.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State var searchText = ""

    var body: some View {
        ZStack {
            Color("black")
                .ignoresSafeArea()

            ScrollView {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Search..", text: $searchText)
                        .foregroundColor(.white)
                        .onChange(of: searchText) {
                            viewModel.searchTracks(with: $0)
                        }
                }
                .padding()
                .background(Color(.gray))
                .cornerRadius(6)
                .padding(.horizontal)

                if let tracks = viewModel.searchedTracks {
                    ForEach(tracks) { track in
                        TrackItemCell(track: track)
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
