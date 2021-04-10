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
                    
                    if (task.response?.statusCode) == nil {
                        return APIError.noInternet
                    }
                    
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
    
    enum DateError: String, Error {
        case invalidDate
    }
    
    let formatter = DateFormatter()
    
    override init() {
        super.init()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = self.formatter.date(from: dateStr) {
                return date
            }
            self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = self.formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
        })
    }
}
