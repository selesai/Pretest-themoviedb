//
//  ReviewsView+CellLoading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension GenresView {
    struct ReviewsView: View {
        var body: some View{
            VStack {
                VStack(spacing: 0){
                    VStack {
                        HStack {
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("light_gray_color"))
                                .frame(width: 30, height: 30)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("light_gray_color"))
                                .frame(maxWidth: 100, maxHeight: 20)
                        }
                        
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
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 5)
        }
    }
}
