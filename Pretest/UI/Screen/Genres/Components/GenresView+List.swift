//
//  GenresView+List.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension GenresView {
    
    struct List : View {
        
        var genres: LazyList<Genres>
        var selection: (Genres) -> Void
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            ScrollView {
                LazyVStack {
                    ForEach(genres.indices, id: \.self) { (index) in
                        GenresView.Cell(genre: genres[index], selection: selection)
                    }
                }
            }
        }
        
    }
}
