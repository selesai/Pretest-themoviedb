//
//  ReviewsView+Loading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension ReviewsView {
    struct Loading: View {
        var body: some View {
            ScrollView{
                LazyVStack(spacing: 0){
                    VStack(spacing: 0){
                        ForEach((0...20).indices, id: \.self) { _ in
                            ReviewsView.CellLoading()
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}
