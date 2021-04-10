//
//  VideosView+Loading.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension VideosView {
    struct Loading: View {
        
        var body: some View {
            ScrollView {
                LazyVStack {
                    ForEach(Array(0..<5), id: \.self) { _ in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("light_gray_color"))
                                .frame(height: 250)
                        }
                        .shimmer(isActive: true)
                    }
                }
                .padding(20)
            }
        }
    }
}
