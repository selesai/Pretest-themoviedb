//
//  ReviewsView+List.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension ReviewsView {
    
    struct List : View {
        
        var reviews: [Reviews]
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            ScrollView {
                LazyVStack {
                    ForEach(reviews.indices, id: \.self) { (index) in
                        ReviewsView.Cell(genre: genres[index], selection: selection)
                    }
                }
            }
        }
        
    }
}
