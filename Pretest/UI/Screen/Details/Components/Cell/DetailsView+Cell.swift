//
//  DetailsView+Cell.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Kingfisher

extension DetailsView {
    struct Cell : View {
        
        var cast: Cast
        
        var body: some View {
            ZStack(alignment: .bottom) {
                ImageView(url: getURL(path: cast.profilePath ?? ""))
                    .cornerRadius(14)
                VStack(alignment: .leading) {
                    Text(cast.name ?? "")
                        .lineLimit(3)
                        .font(.system(size: 16, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                    
                    Text(cast.character ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                        .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .bottom, endPoint: .top))
            }
            .frame(height: 200)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("border_color"), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        
        func initialImage(name: String) -> UIImage {
            let image = name.generateImage(backgroundColor: nil,
                               resize: true,
                               circular: false,
                               textAttributes: [
                                NSAttributedString.Key.foregroundColor : UIColor.white
                               ],
                               gradient: false,
                               gradientColors: nil,
                               size: CGSize(width: 30, height: 30),
                               isInitial: true)
            return image
        }
        
        func getURL(path: String) -> URL {
            return URL(string: "https://www.themoviedb.org/t/p/w500\(path)")!
        }
        
    }
}
