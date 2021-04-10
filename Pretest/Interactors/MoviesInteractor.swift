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
    func get(data: LoadableSubject<LazyList<Movies>>, genre: Int, page: Int)
}

struct RealMoviesInteractor: MoviesInteractor {
    
    let webRepository: MoviesWebRepository
    let appState: Store<AppState>
    let cancelBag = CancelBag()
    
    init(webRepository: MoviesWebRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func get(data: LoadableSubject<LazyList<Movies>>, genre: Int, page: Int) {
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        webRepository.get(genre: genre, page: page)
            .map { (response) -> LazyList<Movies> in
                return (response.results?.lazyList ?? [].lazyList)
            }
            .sinkToLoadable { (result) in
                data.wrappedValue = result
            }
            .store(in: cancelBag)
    }
}

struct StubMoviesInteractor: MoviesInteractor {
    func get(data: LoadableSubject<LazyList<Movies>>, genre: Int, page: Int) { }
}
