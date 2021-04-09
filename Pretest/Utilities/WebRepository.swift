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
    var oauthAuthenticator: OAuthAuthenticator? { get }
    var deviceId: String? { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL, deviceId: deviceId)
            let task = session
                .request(request, interceptor: oauthAuthenticator)
                .validate()
            return task
                .publishDecodable(type: Value.self, decoder: JSONWithDateDecoder())
                .value()
                .mapError { error -> Error in
                    guard let code = task.response?.statusCode else{
                        return APIError.unexpectedResponse
                    }

                    guard let data = task.data else{
                        return APIError.unexpectedResponse
                    }

                    if !httpCodes.contains(code) {
                        do {
                            return APIError.httpCode(try JSONDecoder().decode(ErrorModel.self, from: data))
                        } catch{
                            return error
                        }
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
    
    func upload<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success, multipartFormData: MultipartFormData) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL, deviceId: deviceId)
            let task = session
                .upload(multipartFormData: multipartFormData, with: request, interceptor: oauthAuthenticator)
                .validate()
            
            return task
                .publishDecodable(type: Value.self, decoder: JSONWithDateDecoder())
                .value()
                .mapError { error -> Error in
                    guard let code = task.response?.statusCode else{
                        return APIError.unexpectedResponse
                    }

                    guard let data = task.data else{
                        return APIError.unexpectedResponse
                    }

                    if !httpCodes.contains(code) {
                        do {
                            return APIError.httpCode(try JSONDecoder().decode(ErrorModel.self, from: data))
                        } catch{
                            return error
                        }
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
    
    func download(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<(PDFDocument, Data), Error> {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL, deviceId: deviceId)

            return session
                .request(request, interceptor: oauthAuthenticator)
                .validate()
                .publishData()
                .value()
                .tryMap { (data) -> (PDFDocument, Data) in
                    guard let pdfDocument = PDFDocument(data: data) else { throw APIError.unexpectedResponse }
                    return (pdfDocument, data)
                }
                .extractUnderlyingError()
                .receive(on: DispatchQueue.main)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<(PDFDocument, Data), Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    func downloadWithPreview(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<(PDFDocument, Data, PDFDocument), Error> {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL, deviceId: deviceId)

            return session
                .request(request, interceptor: oauthAuthenticator)
                .validate()
                .publishData()
                .value()
                .tryMap { (data) -> (PDFDocument, Data, PDFDocument) in
                    guard let pdfDocument = PDFDocument(data: data) else { throw APIError.unexpectedResponse }
                    guard let previewDocument = PDFDocument(data: data) else { throw APIError.unexpectedResponse }
                    return (pdfDocument, data, previewDocument)
                }
                .extractUnderlyingError()
                .receive(on: DispatchQueue.main)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<(PDFDocument, Data, PDFDocument), Error>(error: error).eraseToAnyPublisher()
        }
    }
    
    func downloadToFile(endpoint: APICall, httpCodes: HTTPCodes = .success, filename: String, progressHandler: @escaping (Progress) -> Void) -> AnyPublisher<URL?, Error> {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL, deviceId: deviceId)

            let destination: DownloadRequest.Destination = { _, _ in
                var documentsURL = FileManager.default.temporaryDirectory
                documentsURL.appendPathComponent("\(filename).pdf")
                return (documentsURL, [.removePreviousFile])
            }
            
            return session
                .download(request, interceptor: oauthAuthenticator, to: destination)
                .downloadProgress { progress in
                    progressHandler(progress)
                }
                .validate()
                .publishURL()
                .value()
                .tryMap { response -> URL in
                    response
                }
                .extractUnderlyingError()
                .receive(on: DispatchQueue.main)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail<URL?, Error>(error: error).eraseToAnyPublisher()
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
