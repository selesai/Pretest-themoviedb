//
//  SceneDelegate.swift
//  Pretest
//
//  Created by Marsudi Widodo on 09/04/21.
//

import UIKit
import SwiftUI
import Combine
import Foundation

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let shimmerConfig = ShimmerConfig(bgColor: Color.white.opacity(0), shimmerColor: .white)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        let environment = AppEnvironment.bootstrap()
        let contentView = ContentView(container: environment.container)
            .environmentObject(shimmerConfig)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print(">>> sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print(">>> sceneWillResignActive")
    }
}
