//
//  SceneEventStream.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import UIKit
import Combine

enum SceneEvent {
    case none
    case didBecomeActive(UIScene)
    case willResignActive(UIScene)
    case didEnterBackground(UIScene)
    case willEnterForeground(UIScene)
    case didDisconnect(UIScene)
}

protocol SceneEventStream {
    func subscribe() -> AnyPublisher<SceneEvent, Never>
}
