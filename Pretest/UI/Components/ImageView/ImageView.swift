//
//  ImageView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Kingfisher

struct ImageView : View {
    
    let url: URL
    let height: CGFloat
    
    init(url: URL, height: CGFloat = 200) {
        self.url = url
        self.height = height
    }
    
    var body: some View {
        KFImage.url(url)
            .placeholder {
                Image("placeholder_image")
                    .resizable()
                    .frame(height: height)
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}
