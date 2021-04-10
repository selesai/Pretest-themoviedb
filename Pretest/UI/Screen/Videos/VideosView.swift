//
//  VideosView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine

struct VideosView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.videosView)
    }
    
    @State private(set) var data: Loadable<[Videos]>
    let movie: Movies
    
    init(data: Loadable<[Videos]> = .notRequested, movie: Movies) {
        self._data = .init(initialValue: data)
        self.movie = movie
    }
    
    var body: some View {
        self.content
            .onReceive(routingUpdate) { self.routingState = $0 }
            .onAppear {
                self.getVideos()
            }
            .navigationTitle("Videos: \(movie.title ?? "")")
    }
    
    var content: some View {
        GeometryReader { reader in
            self.makeState()
                .background(Color("background_color").edgesIgnoringSafeArea(.all))
        }
    }
    
    func makeState() -> some View {
        switch data {
        case .isLoading:
            return VideosView.Loading().toAnyView
        case let .loaded(videos):
            return VideosView.List(videos: videos).toAnyView
        case let .failed(error):
            return FailedView(message: error.localizedDescription) {
                self.getVideos()
            }
            .toAnyView
        default:
            return VideosView.Loading().toAnyView
        }
    }
}


// MARK: - Side Effects
private extension VideosView {
    func getVideos() {
        guard let id = movie.id else { return }
        injected.interactors.moviesInteractor.videos(data: $data, id: id)
    }
}

// MARK: - Routing
extension VideosView {
    struct Routing: Equatable {
        
    }
}

// MARK: - State Updates
private extension VideosView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.videosView)
    }
}
