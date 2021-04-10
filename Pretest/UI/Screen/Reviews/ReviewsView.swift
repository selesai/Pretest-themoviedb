//
//  ReviewsView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine

struct ReviewsView: View {
    
    @Environment(\.injected) private var injected: DIContainer
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: injected.appState, \.routing.reviewsView)
    }
    
    @State private(set) var data: Loadable<[Reviews]>
    let movie: Movies
    
    init(data: Loadable<[Reviews]> = .notRequested, movie: Movies) {
        self._data = .init(initialValue: data)
        self.movie = movie
    }
    
    var body: some View {
        self.content
            .onReceive(routingUpdate) { self.routingState = $0 }
            .onAppear {
                self.getReviews()
            }
            .navigationTitle("Reviews: \(movie.title ?? "")")
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
            return ReviewsView.Loading().toAnyView
        case let .loaded(reviews):
            return ReviewsView.List(reviews: reviews).toAnyView
        case let .failed(error):
            return GenresView.Failed(message: error.localizedDescription).toAnyView
        default:
            return ReviewsView.Loading().toAnyView
        }
    }
}


// MARK: - Side Effects
private extension ReviewsView {
    func getReviews() {
        guard let id = movie.id else { return }
        injected.interactors.moviesInteractor.reviews(data: $data, id: id, page: routingBinding.page.wrappedValue)
    }
}

// MARK: - Routing
extension ReviewsView {
    struct Routing: Equatable {
        var availableLoadMore: Bool = true
        var page: Int = 1
    }
}

// MARK: - State Updates
private extension ReviewsView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        injected.appState.updates(for: \.routing.reviewsView)
    }
}
