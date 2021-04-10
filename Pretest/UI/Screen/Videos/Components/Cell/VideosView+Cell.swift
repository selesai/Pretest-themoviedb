//
//  VideosView+Cell.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

extension VideosView {
    struct Cell : View {
        
        var video: Videos
        
        var body: some View {
            VStack {
                VStack {
                    YouTubeView(playerState: YouTubeControlState(videoID: video.key ?? ""))
                        .frame(height: 250)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color("border_color"), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 5)
        }
    }
}
