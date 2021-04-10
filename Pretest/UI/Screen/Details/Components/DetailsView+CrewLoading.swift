//
//  DetailsView+CrewLoading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension DetailsView {
    struct CrewLoading: View {
        
        var body: some View {
            ScrollView {
                LazyVStack {
                    ForEach(Array(0..<5), id: \.self) { _ in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("light_gray_color"))
                                .frame(width: 130, height: 30)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("light_gray_color"))
                                .frame(width: 80, height: 30)
                        }
                        .shimmer(isActive: true)
                    }
                }
                .padding(20)
            }
        }
    }
}
