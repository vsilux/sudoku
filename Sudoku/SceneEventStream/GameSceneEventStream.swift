//
//  GameSceneEventStream.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import UIKit
import Combine

class GameSceneEventStream: SceneEventStream {
    @Published private var event: SceneEvent = .none
    
    func subscribe() -> AnyPublisher<SceneEvent, Never> {
        $event.eraseToAnyPublisher()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        event = .didDisconnect(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        event = .didDisconnect(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        event = .willResignActive(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        event = .willEnterForeground(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        event = .didEnterBackground(scene)
    }
}
