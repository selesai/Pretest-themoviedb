//
//  GenresView+Loading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension GenresView {
    struct Loading: View {
        var body: some View {
            ScrollView{
                LazyVStack(spacing: 0){
                    VStack(spacing: 0){
                        ForEach((1...5).indices, id: \.self) { _ in
                            GenresView.CellLoading()
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}
