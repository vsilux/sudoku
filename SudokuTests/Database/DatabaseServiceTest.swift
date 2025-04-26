//
//  DatabaseServiceTest.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 26.04.2025.
//

import XCTest
import GRDB
@testable import Sudoku

final class DatabaseServiceTest: XCTestCase {
    func test_DatabaseService_SudokuGameMode_actions() throws {
        let sut = makeSUT()
        
        var game = SudokuGameModel.testGame
        
        let newInGameTime = 100
        game.time = newInGameTime
        
        try sut.save(game: &game)
        XCTAssertNotNil(game.id, "Game ID should not be nil after saving")
        
        let fetchedGame = try sut.fetchGame(for: game.id!)
        XCTAssertEqual(fetchedGame?.time, newInGameTime, "Fetched game time should match the saved game time")
        
        XCTAssertTrue(try sut.remove(game: game), "Game should be removed successfully")
    }
    
    func test_DatabaseService_gameItems_butch_operations() throws {
        let sut = makeSUT()
        let gameItemsGenerator = SudokuGameItemsGenerator()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        var gameItems = gameItemsGenerator.generateGameItems(for: game)!
        try sut.save(gameItems: &gameItems)
        
        let fetchedItems = try sut.items(for: game)
        
        XCTAssertNotNil(fetchedItems, "Fetched game items should not be nil")
    }
    
    func test_DatabaseService_gameItem_update_operation() throws {
        let sut = makeSUT()
        let gameItemsGenerator = SudokuGameItemsGenerator()
        
        var game = SudokuGameModel.testGame
        try sut.save(game: &game)
        
        var gameItems = gameItemsGenerator.generateGameItems(for: game)!
        try sut.save(gameItems: &gameItems)
        
        var gameItem = gameItems
            .flatMap { $0 }
            .first { $0.value == nil }!
        
        gameItem.value = gameItem.correctValue
        try sut.save(gameItem: &gameItem)
        
        let fetchedItem = try sut.fetchGameItem(for: gameItem.id!)
        XCTAssertEqual(fetchedItem?.value, gameItem.correctValue, "Fetched game item value should match the correct value")
    }
    
    // MARK: - Helper Methods
    
    func makeSUT() -> SudokuDatabaseService {
        return try! DatabaseServiceProvider(
            databaseQueueProvider: MockDatabaseQueueProvider(),
            migrator: SudokuDatabaseMigrator()
        ).service()
    }
}
