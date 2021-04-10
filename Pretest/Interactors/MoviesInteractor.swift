//
//  MoviesInteractor.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import Combine
import Foundation
import SwiftUI

protocol MoviesInteractor {
    func get(data: LoadableSubject<[Movies]>, genre: Int, page: Int)
    func detail(data: LoadableSubject<(MoviesDetail, [Cast], [Crew])>, id: Int)
}

struct RealMoviesInteractor: MoviesInteractor {
    
    let webRepository: MoviesWebRepository
    let appState: Store<AppState>
    let cancelBag = CancelBag()
    
    init(webRepository: MoviesWebRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func get(data: LoadableSubject<[Movies]>, genre: Int, page: Int) {
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        weak var weakAppState = appState
        webRepository.get(genre: genre, page: page)
            .map { (response) -> [Movies] in
                return (response.results ?? [])
            }
            .sinkToLoadable { (result) in
                if page == 1 {
                    data.wrappedValue = result
                    if (data.wrappedValue.value?.isEmpty ?? false) {
                        weakAppState?[\.routing.moviesView.availableLoadMore] = false
                    } else {
                        weakAppState?[\.routing.moviesView.availableLoadMore] = true
                    }
                } else {
                    var movies = data.wrappedValue.value ?? []
                    if let newMovies = result.value {
                        movies.append(contentsOf: newMovies)
                    }
                    if (result.value?.isEmpty ?? false) {
                        weakAppState?[\.routing.moviesView.availableLoadMore] = false
                    } else {
                        weakAppState?[\.routing.moviesView.availableLoadMore] = true
                    }
                    data.wrappedValue = .loaded(movies)
                }
            }
            .store(in: cancelBag)
    }
    
    func detail(data: LoadableSubject<(MoviesDetail, [Cast], [Crew])>, id: Int) {
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        let details = webRepository.detail(id: id)
        let credits = webRepository.credits(id: id)
        
        Publishers.Zip(details, credits)
            .map { (response) -> (MoviesDetail, [Cast], [Crew]) in
                return (response.0, response.1.cast, response.1.crew)
            }
            .sinkToLoadable { (result) in
                data.wrappedValue = result
            }
            .store(in: cancelBag)
    }
}

struct StubMoviesInteractor: MoviesInteractor {
    func get(data: LoadableSubject<[Movies]>, genre: Int, page: Int) { }
    func detail(data: LoadableSubject<(MoviesDetail, [Cast], [Crew])>, id: Int) { }
}
