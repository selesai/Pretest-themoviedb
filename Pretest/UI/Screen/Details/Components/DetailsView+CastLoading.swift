//
//  DetailsView+CastLoading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension DetailsView {
    struct CastLoading: View {
        
        var body: some View {
            ScrollView{
                LazyHStack {
                    ForEach(Array(0..<5), id: \.self) { _ in
                        MoviesView.CellLoading()
                    }
                }
                .padding(20)
            }
        }
    }
}
