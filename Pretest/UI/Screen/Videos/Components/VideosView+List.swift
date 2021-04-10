//
//  VideosView+List.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension VideosView {
    struct List : View {
        
        var videos: [Videos]
        
        var body: some View {
            self.content
        }
        
        var content: some View {
            ScrollView {
                LazyVStack {
                    ForEach(videos.indices, id: \.self) { (index) in
                        VideosView.Cell(video: videos[index])
                    }
                }
            }
        }
        
    }
}
