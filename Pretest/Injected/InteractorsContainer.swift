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
        
        init(genresInteractor: GenresInteractor) {

            self.genresInteractor = genresInteractor
        }
        
        static var stub: Self {
            .init(genresInteractor: StubGenresInteractor())
        }
    }
}
