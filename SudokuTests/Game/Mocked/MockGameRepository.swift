//
//  GameRepositoryMock.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 04.05.2025.
//

import Foundation
import Sudoku

class MockGameRepository: GameRepository {
    static let mockedGaimId: Int64 = 1126
    private(set) var actions: [Action] = []
    
    func save(game: inout SudokuGameModel) throws {
        game.id = MockGameRepository.mockedGaimId
        actions.append(.saveGame(game))
    }
    
    func fetchGame(for id: Int64) throws -> SudokuGameModel? {
        actions.append(.fetchGame(id))
        return SudokuGameModel.testGame
    }
    
    func fetchUnfinishedGames() throws -> [SudokuGameModel] {
        actions.append(.fetchUnfinishedGames)
        return []
    }
    
    func fetchLatestGame() throws -> SudokuGameModel? {
        actions.append(.fetchLatestGame)
        return nil
    }
    
    func delete(game: SudokuGameModel) throws -> Bool {
        actions.append(.deleteGame(game))
        return true
    }
    
    func update(time: Int, for gameId: Int64) throws {
        actions.append(.updateTime(time, gameId))
    }
    
    func update(mistakes: Int, for gameId: Int64) throws {
        actions.append(.updateMistakes(mistakes, gameId))
    }
    
    func update(hints: Int, for gameId: Int64) throws {
        actions.append(.updateHints(hints, gameId))
    }
    
    func update(score: Int, for gameId: Int64) throws {
        actions.append(.updateScore(score, gameId))
    }
}

extension MockGameRepository {
    enum Action {
        case saveGame(SudokuGameModel)
        case fetchGame(Int64)
        case fetchUnfinishedGames
        case fetchLatestGame
        case deleteGame(SudokuGameModel)
        case updateTime(Int, Int64)
        case updateMistakes(Int, Int64)
        case updateHints(Int, Int64)
        case updateScore(Int, Int64)
    }
}
