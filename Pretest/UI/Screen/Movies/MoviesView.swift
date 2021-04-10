//
//  MoviesView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine

struct MoviesView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.moviesView)
    }
    
    @State private(set) var data: Loadable<LazyList<Movies>>
    let genre: Genres
    
    init(data: Loadable<LazyList<Movies>> = .notRequested, genre: Genres) {
        self._data = .init(initialValue: data)
        self.genre = genre
    }
    
    var body: some View {
        self.content
            .onReceive(routingUpdate) { self.routingState = $0 }
            .onAppear {
                self.getMovies()
            }
            .navigationTitle("Discover: \(genre.name ?? "")")
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
            return MoviesView.Loading().toAnyView
        case let .loaded(movies):
            return MoviesView.List(movies: movies).toAnyView
        case let .failed(error):
            return GenresView.Failed(message: error.localizedDescription).toAnyView
        default:
            return MoviesView.Loading().toAnyView
        }
    }
}


// MARK: - Side Effects
private extension MoviesView {
    func getMovies() {
        injected.interactors.moviesInteractor.get(data: $data, genre: genre.id, page: 1)
    }
}

// MARK: - Routing
extension MoviesView {
    struct Routing: Equatable {
        
    }
}

// MARK: - State Updates
private extension MoviesView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.moviesView)
    }
}
