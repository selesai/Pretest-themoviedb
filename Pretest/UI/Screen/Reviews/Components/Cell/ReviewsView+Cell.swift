//
//  ReviewsView+Cell.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension ReviewsView {
    struct Cell : View {
        
        var review: Reviews
        @State var expanded: Bool = false
        
        var body: some View {
            VStack {
                VStack(spacing: 0){
                    VStack {
                        HStack(alignment: .center) {
                            ImageView(url: getURL(path: review.authorDetails?.avatarPath ?? ""))
                                .frame(width: 30, height: 30)
                                .cornerRadius(14)
                            
                            Text(review.author ?? "-")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black)
                            
                            Spacer()
                            
                            Text(review.createdAt?.toStringWithFormat("MMM d") ?? "")
                                .font(.system(size: 12))
                                .foregroundColor(Color.gray)
                                .italic()
                            
                            Image(systemName: expanded ? "chevron.up" : "chevron.down")
                                .resizable()
                                .foregroundColor(Color.gray)
                                .frame(width: 15, height: 8)
                                .onTapGesture {
                                    withAnimation {
                                        self.expanded.toggle()
                                    }
                                }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(review.content ?? "-")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                            .lineLimit(expanded ? 100 : 3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
        
        func getURL(path: String) -> URL {
            return URL(string: "https://www.themoviedb.org/t/p/w200\(path)")!
        }
    }
}
