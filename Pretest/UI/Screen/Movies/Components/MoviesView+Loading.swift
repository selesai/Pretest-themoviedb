//
//  MoviesView+Loading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension MoviesView {
    struct Loading: View {
        
        let columns = Array(repeating: GridItem(), count: 2)
        
        var body: some View {
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(Array(0..<20), id: \.self) { _ in
                        MoviesView.CellLoading()
                    }
                }
                .padding(20)
            }
        }
    }
}
