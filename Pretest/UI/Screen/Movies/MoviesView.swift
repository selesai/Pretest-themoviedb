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
    
    @State private(set) var data: Loadable<[Movies]>
    let genre: Genres
    
    init(data: Loadable<[Movies]> = .notRequested, genre: Genres) {
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
            .sheet(isPresented: routingBinding.presentedDetail, content: {
                if let movie = routingBinding.movie.wrappedValue {
                    DetailsView(movie: movie, presented: routingBinding.presentedDetail).inject(injected)
                } else {
                    Text("")
                }
            })
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
            if (data.value?.count ?? 0 > 0), let movies = data.value {
                return MoviesView.List(movies: movies, availableLoadMore: routingBinding.availableLoadMore.wrappedValue) { (movie) in
                    routingBinding.movie.wrappedValue = movie
                    routingBinding.presentedDetail.wrappedValue = true
                } onLoadMore: {
                    routingBinding.page.wrappedValue += 1
                    self.getMovies()
                }
                .toAnyView
            } else {
                return MoviesView.Loading().toAnyView
            }
        case let .loaded(movies):
            return MoviesView.List(movies: movies, availableLoadMore: routingBinding.availableLoadMore.wrappedValue) { (movie) in
                routingBinding.movie.wrappedValue = movie
                routingBinding.presentedDetail.wrappedValue = true
            } onLoadMore: {
                routingBinding.page.wrappedValue += 1
                self.getMovies()
            }
            .toAnyView
        case let .failed(error):
            return FailedView(message: error.localizedDescription) {
                routingBinding.page.wrappedValue = 1
                self.getMovies()
            }
            .toAnyView
        default:
            return MoviesView.Loading().toAnyView
        }
    }
}


// MARK: - Side Effects
private extension MoviesView {
    func getMovies() {
        injected.interactors.moviesInteractor.get(data: $data, genre: genre.id, page: routingBinding.page.wrappedValue)
    }
}

// MARK: - Routing
extension MoviesView {
    struct Routing: Equatable {
        var presentedDetail: Bool = false
        var movie: Movies?
        var page: Int = 1
        var availableLoadMore: Bool = true
    }
}

// MARK: - State Updates
private extension MoviesView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.moviesView)
    }
}
