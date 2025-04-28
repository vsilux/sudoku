//
//  GameRepositoryTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 27.04.2025.
//

import XCTest
@testable import Sudoku

final class GameRepositoryTests: XCTestCase {
    func test_GameRepository_SudokuGameMode_actions() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        
        let newInGameTime = 100
        game.time = newInGameTime
        
        try sut.save(game: &game)
        XCTAssertNotNil(game.id, "Game ID should not be nil after saving")
        
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.time, newInGameTime, "Fetched game time should match the saved game time")
        
        XCTAssertTrue(try sut.delete(game: game), "Game should be removed successfully")
    }
    
    func test_GameRepository_SudokuGameModel_fetch_unfinished() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        
        for _ in 0..<3 {
            try sut.save(game: &game)
            game = SudokuGameModel.testGame
        }
        
        game.isSolved = true
        try sut.save(game: &game)
        
        let unfinishedGames = try sut.fetchUnfinishedGames()
        XCTAssertEqual(unfinishedGames.count, 3, "There should be 3 unfinished games")
    }
    
    func test_GameRepository_fetch_last_game() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        
        for _ in 0..<3 {
            try sut.save(game: &game)
            game = SudokuGameModel.testGame
        }
        
        try sut.save(game: &game)
        let lastGame = try sut.fetchLatestGame()
        
        XCTAssertEqual(lastGame, game, "Last game ID should match the saved game ID")
    }
    
    func test_GameRepository_game_update_time() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        try sut.update(time: 300, for: game.id!)
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.time, 300, "Fetched game time should match the updated time")
    }
    
    func test_GameRepository_game_updateMistakesCount() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        try sut.update(mistakes: 5, for: game.id!)
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.mistakes, 5, "Fetched game mistakes count should match the updated count")
    }
    
    func test_GameRepository_game_updateHintsCount() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        try sut.update(hints: 2, for: game.id!)
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.hints, 2, "Fetched game hints count should match the updated count")
    }
    
    func test_GameRepository_game_updateScore() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        try sut.update(score: 1500, for: game.id!)
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.score, 1500, "Fetched game score should match the updated score")
    }
    
    // MARK: - Helper Methods
    
    func makeSUT() -> GameRepository {
        return try! SudokuRepositoriesProvider(
            databaseQueueProvider: MockDatabaseQueueProvider(),
            migrator: SudokuDatabaseMigrator()
        ).gameRepository()
    }
}

