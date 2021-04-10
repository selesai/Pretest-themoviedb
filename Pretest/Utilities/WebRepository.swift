//
//  WebRepository.swift
//  CountriesSwiftUI
//
//  Created by Marsudi Widodo on 23.10.2019.
//  Copyright © 2019 Marsudi Widodo. All rights reserved.
//

import Foundation
import Combine
import Alamofire
import PDFKit

protocol WebRepository {
    var session: Session { get }
    var baseURL: String { get }
    var bgQueue: DispatchQueue { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            let task = session
                .request(request)
                .validate()
            return task
                .publishDecodable(type: Value.self, decoder: JSONWithDateDecoder())
                .value()
                .mapError { error -> Error in
                    guard (task.response?.statusCode) != nil else {
                        return APIError.unexpectedResponse
                    }

                    guard task.data != nil else {
                        return APIError.unexpectedResponse
                    }

                    return error
                }
                .extractUnderlyingError()
                .receive(on: DispatchQueue.main)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}

class JSONWithDateDecoder: JSONDecoder {
    let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}
