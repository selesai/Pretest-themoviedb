//
//  DetailsView+CrewList.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension DetailsView {
    struct CrewList : View {
        
        var crews: [Crew]
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text("Crew")
                    .font(.system(size: 16, weight: .heavy, design: .default))
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 20)
                
                LazyVStack {
                    ForEach(crews.indices, id: \.self) { (index) in
                        VStack(alignment: .leading) {
                            Text(crews[index].name ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(Color.black)
                            
                            Text(crews[index].job ?? "")
                                .font(.system(size: 12))
                                .foregroundColor(Color.gray)
                                .italic()
                            
                            Divider()
                                .padding(.vertical, 5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}
