//
//  SceneDelegate.swift
//  Sudoku
//
//  Created by Illia Suvorov on 03.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var sceneEventStream: GameSceneEventStream = GameSceneEventStream()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        App.run(in: window, sceneEventStream: sceneEventStream)
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        sceneEventStream.sceneDidDisconnect(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        sceneEventStream.sceneDidBecomeActive(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        sceneEventStream.sceneWillResignActive(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        sceneEventStream.sceneWillEnterForeground(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        sceneEventStream.sceneDidEnterBackground(scene)
    }
}
