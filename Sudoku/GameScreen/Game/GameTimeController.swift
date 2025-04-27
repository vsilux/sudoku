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
    private var sceneEventCancalable: AnyCancellable?
    private var timer: Timer?
    private let gameId: Int64
    private let repository: GameRepository
    @Published private var inGameTime: Int = 0
    
    deinit {
        timer?.invalidate()
    }
    
    init(game: SudokuGameModel, repository: GameRepository, sceneEventStream: SceneEventStream) {
        self.repository = repository
        inGameTime = game.time
        gameId = game.id!
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
        $inGameTime.eraseToAnyPublisher()
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
            self.inGameTime += 1
            try? self.repository.updateTime(gameId: self.gameId, time: self.inGameTime)
        }
    }
    
    private func invalidateTimer() {
        guard let timer = self.timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    func currentTime() -> Int {
        inGameTime
    }
}
