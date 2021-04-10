//
//  YoutubeControlState.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

enum playerCommandToExecute {
    case loadNewVideo
    case play
    case pause
    case forward
    case backward
    case stop
    case idle
}

class YouTubeControlState: ObservableObject {
    
    @Published var videoID: String?
    @Published var videoState: playerCommandToExecute = .loadNewVideo
    @Published var executeCommand: playerCommandToExecute = .idle
    
    func playPauseButtonTapped() {
        if videoState == .play {
            pauseVideo()
        } else if videoState == .pause {
            playVideo()
        } else {
            print("Unknown player state, attempting playing")
            playVideo()
        }
    }
    
    func playVideo() {
        executeCommand = .play
    }
    
    func pauseVideo() {
        executeCommand = .pause
    }
    
    func forward() {
        executeCommand = .forward
    }
    
    func backward() {
        executeCommand = .backward
    }
    
    init(videoID: String) {
        self.videoID = videoID
    }
}
