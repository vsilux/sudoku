//
//  GameTimeController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import Foundation
import Combine

class GameTimeController: GameTimeCounter {
    private let sceneEventStream: SceneEventStream
    private let gameInteractor: GameInteractor
    
    private var timer: Timer?
    private var sceneEventCancalable: AnyCancellable?
    
    deinit {
        timer?.invalidate()
    }
    
    init(gameInteractor: GameInteractor, sceneEventStream: SceneEventStream) {
        self.gameInteractor = gameInteractor
        self.sceneEventStream = sceneEventStream
    }
    
    func startGame() {
        scheduledTimer()
        sceneEventCancalable = sceneEventStream.subscribe().sink { [weak self] event in
            self?.handleSceneEvent(event)
        }
    }
    
    func stopGame() {
        invalidateTimer()
        self.sceneEventCancalable = nil
    }
    
    func time() -> AnyPublisher<Int, Never> {
        gameInteractor.gamePublisher.map { game in
            game.time
        }.eraseToAnyPublisher()
    }
    
    private func handleSceneEvent(_ event: SceneEvent) {
        switch event {
        case .didBecomeActive(_):
            scheduledTimer()
        case .willResignActive(_):
            invalidateTimer()
        default:
            return
        }
    }
    
    private func scheduledTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.gameInteractor.update(time: gameInteractor.game.time + 1)
        }
    }
    
    private func invalidateTimer() {
        guard let timer = self.timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    func currentTime() -> Int {
        gameInteractor.game.time
    }
}
