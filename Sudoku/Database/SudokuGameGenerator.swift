//
//  GameGenerator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import Foundation

protocol GameGenerator {
    func generateGame(difficulty: SudokuGameModel.Difficulty) throws -> (
        game: SudokuGameModel,
        items: [[SudokuGameItemModel]]
    )
}

class SudokuGameGenerator: GameGenerator {
    let repositoryProvider: RepositoryProvider
    
    init(repositoryProvider: RepositoryProvider) {
        self.repositoryProvider = repositoryProvider
    }
    
    func generateGame(difficulty: SudokuGameModel.Difficulty) throws -> (
        game: SudokuGameModel,
        items: [[SudokuGameItemModel]]
    ) {
        let gameRepository = repositoryProvider.gameRepository()
        if let lastGame = try gameRepository.fetchLatestGame() {
            _ = try gameRepository.delete(game: lastGame)
        }
        
        var game = SudokuGameModel(difficulty: difficulty)
        try gameRepository.save(game: &game)
        
        var gameItems = try SudokuGameItemsGenerator().generateGameItems(
            for: game
        )
        try repositoryProvider.gameItemRepository().save(gameItems: &gameItems)
        
        return (game, gameItems)
        
    }
}
