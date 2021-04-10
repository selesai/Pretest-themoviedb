//
//  MoviesView+Cell.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Kingfisher

extension MoviesView {
    struct Cell : View {
        
        var movie: Movies
        
        var body: some View {
            ZStack(alignment: .bottom) {
                ImageView(url: getURL(path: movie.posterPath ?? ""))
                VStack(alignment: .leading) {
                    Text(movie.title ?? "")
                        .lineLimit(3)
                        .font(.system(size: 16, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color.yellow)
                        
                        Text(movie.voteAverage?.rounded(toPlaces: 1).asString ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
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
    
    struct ImageView : View {
        
        let url: URL
        
        var body: some View {
            KFImage.url(url)
                .placeholder {
                    Image("placeholder_image")
                }
                .fade(duration: 0.25)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(14)
        }
    }
}
