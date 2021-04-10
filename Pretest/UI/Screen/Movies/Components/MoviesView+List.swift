//
//  MoviesView+List.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension MoviesView {
    struct List : View {
        
        var movies: [Movies]
        var selection: (Movies) -> Void
        var onLoadMore: () -> Void
        let columns = Array(repeating: GridItem(), count: 2)
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(movies.indices, id: \.self) { (index) in
                        MoviesView.Cell(movie: movies[index], selection: selection)
                    }
                    
                    MoviesView.CellLoading()
                        .onAppear(perform: onLoadMore)
                }
                .padding(20)
            }
        }
        
    }
}
