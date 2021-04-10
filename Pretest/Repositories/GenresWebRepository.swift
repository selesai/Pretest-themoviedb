//
//  GenresWebRepository.swift
//  Pretest
//
//  Created by Marsudi Widodo on 10/04/21.
//

import SwiftUI
import Combine
import Foundation
import Alamofire

protocol GenresWebRepository: WebRepository {
    func get() -> AnyPublisher<GenresArrayResponse, Error>
}

struct RealGenresWebRepository: GenresWebRepository {
    let session: Session
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: Session, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func get() -> AnyPublisher<GenresArrayResponse, Error> {
        return call(endpoint: API.get)
    }
}

// MARK: - Endpoints
extension RealGenresWebRepository {
    enum API {
        case get
    }
}

extension RealGenresWebRepository.API: APICall {
    var path: String {
        switch self {
        case .get:
            return "/3/genre/movie/list"
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
