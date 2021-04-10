//
//  ContentView.swift
//  Pretest
//
//  Created by Marsudi Widodo on 09/04/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    private let container: DIContainer
    private let isRunningTests: Bool
    
    @State private var routingState: Routing = .init()
    private var routingBinding: Binding<Routing> {
        $routingState.dispatched(to: container.appState, \.routing.contentView)
    }
    
    init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
        self.container = container
        self.isRunningTests = isRunningTests
    }
    
    var body: some View {
        self.content
            .inject(container)
    }
    
    var content: some View {
        return AnyView(Text(""))
    }
}

// MARK: - Routing
extension ContentView {
    struct Routing: Equatable {
        //popup
        var popupIcon: String?
        var popupMessage: String = ""
        var popupPresent: Bool = false
        var popupType: BannerPopup.PopupType = .default
    }
}

// MARK: - State Updates
private extension ContentView {
    var routingUpdate: AnyPublisher<Routing, Never> {
        container.appState.updates(for: \.routing.contentView)
    }
}
