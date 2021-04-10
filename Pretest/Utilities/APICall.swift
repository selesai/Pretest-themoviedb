//
//  APICall.swift
//  CountriesSwiftUI
//
//  Created by Marsudi Widodo on 23.10.2019.
//  Copyright © 2019 Marsudi Widodo. All rights reserved.
//

import Foundation

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

enum APIError: Swift.Error {
    case invalidURL
    case unexpectedResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .unexpectedResponse: return "Unexpected response from the server"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String, deviceId: String? = nil) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        let currentQueryParameter = url.queryDictionary
        var queryParameterWithApiKey = ["api_key": "be8b6c8aa9a5f4e240bb6093f9849051"]
        if let currentQueryParameter = currentQueryParameter {
            queryParameterWithApiKey.merge(dict: currentQueryParameter)
        }
        
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.query = queryParameterWithApiKey.queryString
        
        guard let urlWithApiKey = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: urlWithApiKey)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
