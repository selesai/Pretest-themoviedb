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
    func credits(id: Int) -> AnyPublisher<CreditsArrayResponse, Error>
    func detail(id: Int) -> AnyPublisher<MoviesDetail, Error>
    func videos(id: Int) -> AnyPublisher<VideosArrayResponse, Error>
    func reviews(id: Int, page: Int) -> AnyPublisher<ReviewsArrayResponse, Error>
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
        return call(endpoint: API.get(genre: genre, page: page))
    }
    
    func detail(id: Int) -> AnyPublisher<MoviesDetail, Error> {
        return call(endpoint: API.detail(id: id))
    }
    
    func credits(id: Int) -> AnyPublisher<CreditsArrayResponse, Error> {
        return call(endpoint: API.credits(id: id))
    }
    
    func videos(id: Int) -> AnyPublisher<VideosArrayResponse, Error> {
        return call(endpoint: API.videos(id: id))
    }
    
    func reviews(id: Int, page: Int) -> AnyPublisher<ReviewsArrayResponse, Error> {
        return call(endpoint: API.reviews(id: id, page: page))
    }
}

// MARK: - Endpoints
extension RealMoviesWebRepository {
    enum API {
        case get(genre: Int, page: Int)
        case credits(id: Int)
        case detail(id: Int)
        case videos(id: Int)
        case reviews(id: Int, page: Int)
    }
}

extension RealMoviesWebRepository.API: APICall {
    var path: String {
        switch self {
        case let .get(genre, page):
            return "/3/discover/movie?with_genres=\(genre)&page=\(page)"
        case let .credits(id):
            return "/3/movie/\(id)/credits"
        case let .detail(id):
            return "/3/movie/\(id)"
        case let .videos(id):
            return "/3/movie/\(id)/videos"
        case let .reviews(id, page):
            return "/3/movie/\(id)/reviews?page=\(page)"
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
