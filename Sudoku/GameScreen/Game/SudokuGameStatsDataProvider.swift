//
//  SudokuGameStatsDataProvider.swift
//  Sudoku
//
//  Created by Illia Suvorov on 02.05.2025.
//

import Foundation
import Combine

class SudokuGameStatsDataProvider: GameStatsDataProvider {
    typealias Index = GameBoardIndex
    private let gameInteractor: GameInteractor
    let timeCounter: GameTimeCounter
    
    
    init(
        gameInteractor: GameInteractor,
        timeCounter: GameTimeCounter,
    ) {
        self.gameInteractor = gameInteractor
        self.timeCounter = timeCounter
    }
    
    func gameStats() -> any GameStats {
        return GameStatsModel(
            difficulty: gameInteractor.game.difficulty.name,
            mistakesCount: gameInteractor.game.mistakes,
            time: timeCounter.currentTime(),
            score: gameInteractor.game.score,
            maxScore: 0
        )
    }
    
    func mistakes() -> AnyPublisher<Int, Never> {
        gameInteractor.gamePublisher.map { $0.mistakes }
            .eraseToAnyPublisher()
    }
}
