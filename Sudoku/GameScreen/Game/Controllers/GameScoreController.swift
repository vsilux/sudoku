//
//  GameScoreController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 01.05.2025.
//

import Foundation
import Combine

protocol GameScoreController {
    func updateScore(for index: GameBoardIndex)
}

class SudokuGameScoreController: GameScoreController {
    private let gameInteractor: GameInteractor
    private var indices = Set<GameBoardIndex>()
    
    init(gameInteractor: GameInteractor, gameItemModels: [[SudokuGameItemModel]]) {
        self.gameInteractor = gameInteractor
        fillIndices(with: gameItemModels)
    }
    
    private func fillIndices(with gameItemModels: [[SudokuGameItemModel]]) {
        for row in gameItemModels {
            for item in row {
                if item.value == item.correctValue {
                    indices.insert(GameBoardIndex(row: item.row, column: item.column))
                }
            }
        }
    }
    
    func updateScore(for index: GameBoardIndex) {
        guard !indices.contains(index) else { return }
        
        let inGameTime = gameInteractor.game.time
        let basePints = 100.0
        
        // 10 minutes decay
        let timeDecayFactor = max(0.1, 1.0 - Double(inGameTime) / 600.0)
        
        gameInteractor.update(score: gameInteractor.game.score + Int(basePints * timeDecayFactor))
        indices.insert(index)
    }
}

extension SudokuGameScoreController: GameScoreProvider {
    func score() -> any Publisher<Int, Never> {
        gameInteractor.gamePublisher.map { $0.score }
            .eraseToAnyPublisher()
    }
}
