//
//  GenresInteractor.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import Combine
import Foundation
import SwiftUI

protocol GenresInteractor {
    func get(data: LoadableSubject<LazyList<Genres>>)
}

struct RealGenresInteractor: GenresInteractor {
    
    let webRepository: GenresWebRepository
    let appState: Store<AppState>
    let cancelBag = CancelBag()
    
    init(webRepository: GenresWebRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func get(data: LoadableSubject<LazyList<Genres>>) {
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        webRepository.get()
            .map { (response) -> LazyList<Genres> in
                return (response.genres?.lazyList ?? [].lazyList)
            }
            .sinkToLoadable { (result) in
                data.wrappedValue = result
            }
            .store(in: cancelBag)
    }
}

struct StubGenresInteractor: GenresInteractor {
    func get(data: LoadableSubject<LazyList<Genres>>) { }
}
