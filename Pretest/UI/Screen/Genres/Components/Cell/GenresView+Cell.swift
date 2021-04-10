//
//  GenresView+Cell.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension GenresView {
    struct Cell : View {
        
        var genre: Genres
        
        var body: some View {
            VStack {
                VStack(spacing: 0){
                    HStack(alignment: .center){
                        Image(uiImage: initialImage(name: genre.name ?? "Uncategorized"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(genre.name ?? "Uncategorized")
                            .font(.system(size: 14))
                            .foregroundColor(Color.black)
                    }
                    .padding([.top, .leading, .trailing], 10)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("border_color"), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 5)
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
        
    }
}
