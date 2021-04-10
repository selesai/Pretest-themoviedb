//
//  DIContainer.Interactors.swift
//  CountriesSwiftUI
//
//  Created by Marsudi Widodo on 24.10.2019.
//  Copyright © 2019 Marsudi Widodo. All rights reserved.
//

extension DIContainer {
    struct Interactors {
        let genresInteractor: GenresInteractor
        let moviesInteractor: MoviesInteractor
        
        init(genresInteractor: GenresInteractor, moviesInteractor: MoviesInteractor) {

            self.genresInteractor = genresInteractor
            self.moviesInteractor = moviesInteractor
        }
        
        static var stub: Self {
            .init(genresInteractor: StubGenresInteractor(), moviesInteractor: StubMoviesInteractor())
        }
    }
}
