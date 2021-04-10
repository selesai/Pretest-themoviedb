//
//  MoviesView+CellLoading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension MoviesView {
    struct CellLoading: View {
        var body: some View{
            VStack {
                VStack(spacing: 0){
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("light_gray_color"))
                            .frame(height: 200)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("light_gray_color"))
                            .frame(maxWidth: .infinity, maxHeight: 20)
                    }
                    .padding([.top, .leading, .trailing], 10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .shimmer(isActive: true)
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("border_color"), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
