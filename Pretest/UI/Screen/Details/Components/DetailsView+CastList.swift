//
//  DetailsView+CastList.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension DetailsView {
    struct CastList : View {
        
        var casts: [Cast]
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Cast")
                    .font(.system(size: 16, weight: .heavy, design: .default))
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(casts.indices, id: \.self) { (index) in
                            DetailsView.Cell(cast: casts[index])
                                .frame(width: 160)
                        }
                    }
                    .padding(20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}
