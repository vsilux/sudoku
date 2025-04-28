//
//  GameInteractor.swift
//  Sudoku
//
//  Created by Illia Suvorov on 28.04.2025.
//

import Foundation
import Combine

protocol GameInteractor {
    var game: SudokuGameModel { get }
    var gamePublished: Published<SudokuGameModel> { get }
    var gamePublisher: Published<SudokuGameModel>.Publisher { get }
    
    func update(time: Int)
    func update(mistakesCount: Int)
}

class SudokuGameInteractor: GameInteractor {
    private let repository: GameRepository
    @Published private(set) var game: SudokuGameModel
    var gamePublished: Published<SudokuGameModel> { _game }
    var gamePublisher: Published<SudokuGameModel>.Publisher { $game }
    
    init(game: SudokuGameModel, repository: GameRepository) {
        self.game = game
        self.repository = repository
    }
    
    func update(time: Int) {
        game.time = time
        try? repository.update(time: time, for: game.id!)
    }
    
    func update(mistakesCount: Int) {
        game.mistakes = mistakesCount
        try? repository.update(mistakes: mistakesCount, for: game.id!)
    }
    
    func update(hints: Int) {
        game.hints = hints
        try? repository.update(hints: hints, for: game.id!)
    }
    
    func update(score: Int) {
        game.score = score
        try? repository.update(score: score, for: game.id!)
    }
}
