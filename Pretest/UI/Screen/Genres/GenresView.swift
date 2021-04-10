//
//  GenresView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine

struct GenresView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.genresView)
    }
    
    @State private(set) var data: Loadable<LazyList<Genres>>
    
    init(data: Loadable<LazyList<Genres>> = .notRequested) {
        self._data = .init(initialValue: data)
    }
    
    var body: some View {
        self.content
            .onReceive(routingUpdate) { self.routingState = $0 }
            .onAppear {
                self.getGenres()
            }
    }
    
    var content: some View {
        NavigationView {
            GeometryReader { reader in
                
                // use navigation here
                // for document cell
                NavigationLink(destination: routingBinding.currentGenre.wrappedValue != nil ? MoviesView(genre: routingBinding.currentGenre.wrappedValue!).toAnyView : Text("").toAnyView,
                               tag: routingBinding.currentTag.wrappedValue,
                               selection: routingBinding.selectionTag)
                    { EmptyView().hidden() }
            
                self.makeState()
                    .background(Color("background_color").edgesIgnoringSafeArea(.all))
            }
            .navigationTitle("Genres")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func makeState() -> some View {
        switch data {
        case .isLoading:
            return GenresView.Loading().toAnyView
        case let .loaded(genres):
            return GenresView.List(genres: genres) { (genre) in
                routingBinding.currentGenre.wrappedValue = genre
                routingBinding.currentTag.wrappedValue = genre.id
                routingBinding.selectionTag.wrappedValue = genre.id
            }.toAnyView
        case let .failed(error):
            return GenresView.Failed(message: error.localizedDescription).toAnyView
        default:
            return GenresView.Loading().toAnyView
        }
    }
}


// MARK: - Side Effects
private extension GenresView {
    func getGenres() {
        injected.interactors.genresInteractor.get(data: $data)
    }
}

// MARK: - Routing
extension GenresView {
    struct Routing: Equatable {
        var currentGenre: Genres?
        var currentTag: Genres.GenreID = 0
        var selectionTag: Genres.GenreID?
    }
}

// MARK: - State Updates
private extension GenresView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.genresView)
    }
}
