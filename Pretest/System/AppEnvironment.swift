//
//  AppEnvironment.swift
//  Pretest
//
//  Created by Marsudi Widodo on 09/04/21.
//

import UIKit
import Combine
import Alamofire

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let session = configuredURLSession()
        
        let webRepositories = configuredWebRepositories(session: session)

        let interactors = configuredInteractors(appState: appState,
                                                webRepositories: webRepositories)
        
        let diContainer = DIContainer(appState: appState,
                                      interactors: interactors)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        let urlSession = Session(configuration: configuration)
        return urlSession
    }
    
    private static func configuredWebRepositories(session: Session) -> DIContainer.WebRepositories {
        
        let genresWebRepository = RealGenresWebRepository(session: session,
                                                        baseURL: "")
        return .init(genresWebRepository: genresWebRepository)
    }
    
    private static func configuredInteractors(appState: Store<AppState>,
                                              webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Interactors {
        
        let genresInteractor = RealGenresInteractor(webRepository: webRepositories.genresWebRepository, appState: appState)
        return .init(genresInteractor: genresInteractor)
    }
}

extension DIContainer {
    struct WebRepositories {
        let genresWebRepository: GenresWebRepository
    }
}
