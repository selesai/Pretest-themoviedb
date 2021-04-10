//
//  Genres.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI

struct GenresArrayResponse: Codable, Equatable {
    let genres: [Genres]?
}

struct Genres: Codable, Equatable {
    let id: GenreID
    let name: String?
    
    typealias GenreID = Int
}
