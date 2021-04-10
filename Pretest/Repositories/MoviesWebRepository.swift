//
//  MoviesWebRepository.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine
import Foundation
import Alamofire

protocol MoviesWebRepository: WebRepository {
    func get(genre: Int, page: Int) -> AnyPublisher<MoviesArrayResponse, Error>
}

struct RealMoviesWebRepository: MoviesWebRepository {
    let session: Session
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: Session, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func get(genre: Int, page: Int) -> AnyPublisher<MoviesArrayResponse, Error> {
        print("call")
        return call(endpoint: API.get(genre: genre, page: page))
    }
}

// MARK: - Endpoints
extension RealMoviesWebRepository {
    enum API {
        case get(genre: Int, page: Int)
    }
}

extension RealMoviesWebRepository.API: APICall {
    var path: String {
        switch self {
        case let .get(genre, page):
            return "/3/discover/movie?with_genres=\(genre)&page=\(page)"
        }
    }
    
    var method: String {
        switch self {
        default: return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
    
    func body() throws -> Data? {
        switch self {
        default: return nil
        }
    }
}
