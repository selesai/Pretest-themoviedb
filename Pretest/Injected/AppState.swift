//
//  AppState.swift
//  CountriesSwiftUI
//
//  Created by Marsudi Widodo on 23.10.2019.
//  Copyright © 2019 Marsudi Widodo. All rights reserved.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct ViewRouting: Equatable {
        var contentView = ContentView.Routing()
        var genresView = GenresView.Routing()
        var moviesView =  MoviesView.Routing()
        var detailsView = DetailsView.Routing()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.routing == rhs.routing &&
        lhs.system == rhs.system
}
