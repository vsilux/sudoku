//
//  DatabaseServiceTest.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 26.04.2025.
//

import XCTest
import GRDB
@testable import Sudoku

final class GameItemRepositoryTests: XCTestCase {
    func test_DatabaseService_gameItems_butch_operations() throws {
        var game = SudokuGameModel.testGame
        let sut = makeSUT(&game)
        let gameItemsGenerator = SudokuGameItemsGenerator()
        
        var gameItems = try gameItemsGenerator.generateGameItems(for: game)
        try sut.save(gameItems: &gameItems)
        
        let fetchedItems = try sut.items(for: game)
        
        XCTAssertNotNil(fetchedItems, "Fetched game items should not be nil")
    }
    
    func test_DatabaseService_gameItem_update_operation() throws {
        var game = SudokuGameModel.testGame
        let sut = makeSUT(&game)
        let gameItemsGenerator = SudokuGameItemsGenerator()
                
        var gameItems = try gameItemsGenerator.generateGameItems(for: game)
        try sut.save(gameItems: &gameItems)
        
        var gameItem = gameItems
            .flatMap { $0 }
            .first { $0.value == nil }!
        
        gameItem.value = gameItem.correctValue
        try sut.save(gameItem: &gameItem)
        
        let fetchedItem = try sut.fetchGameItem(for: gameItem.id!)
        XCTAssertEqual(fetchedItem?.value, gameItem.correctValue, "Fetched game item value should match the correct value")
    }
    
    func test_DatabaseService_gameItem_update_value() throws {
        var game = SudokuGameModel.testGame
        let sut = makeSUT(&game)
        
        var gameItem = SudokuGameItemModel.testItem(gameId: game.id!)
        try sut.save(gameItem: &gameItem)
        
        try sut.updateGameItem(id: gameItem.id!, value: 7)
        
        let fetchedItem = try sut.fetchGameItem(for: gameItem.id!)
        
        XCTAssertEqual(fetchedItem?.value, 7, "Fetched game item value should match the updated value")
    }
    
    // MARK: - Helper Methods
    
    func makeSUT(_ game: inout SudokuGameModel) -> GameItemRepository {
        let repositoryProvider = try! SudokuRepositoriesProvider(
            databaseQueueProvider: MockDatabaseQueueProvider(),
            migrator: SudokuDatabaseMigrator()
        )
        
        try! repositoryProvider.gameRepository().save(game: &game)
        
        return repositoryProvider.gameItemRepository()
    }
}
