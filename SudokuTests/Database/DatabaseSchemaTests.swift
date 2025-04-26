//
//  GameModelsTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 25.04.2025.
//

import XCTest
import GRDB
@testable import Sudoku

final class DatabaseSchemaTests: XCTestCase {
    
    func test_SudokuGameModel_write_and_read() throws {
        let dbQueue = try makeDbQueue()
        
        var sut = SudokuGameModel.testGame
        let writtenGame = try dbQueue.write { db in
            try sut.insert(db)
            return try SudokuGameModel.fetchOne(db)
        }
        
        XCTAssertEqual(
            sut,
            writtenGame,
            "Written game should be equal to the inserted game"
        )
        
        let fetchedGame = try dbQueue.read { db in
            try SudokuGameModel.fetchOne(db)
        }
        
        XCTAssertEqual(
            sut,
            fetchedGame,
            "Fetched game should be equal to the inserted game"
        )
    }
    
    func test_SudokuGameItemModel_write_and_read() throws {
        let dbQueue = try makeDbQueue()
        
        let testGame = try dbQueue.write { db in
            var game = SudokuGameModel.testGame
            try game.insert(db)
            return try SudokuGameModel.fetchOne(db)
        }
        
        var sut = SudokuGameItemModel.testItem(gameId: testGame!.id!)
        // Write
        let writtenGameItem = try dbQueue.write { db in
            try sut.insert(db)
            return try SudokuGameItemModel.fetchOne(db)
        }
        
        XCTAssertEqual(
            sut,
            writtenGameItem,
            "Written gameItem should be equal to the inserted gameItem"
        )
            
        // Read
        let fetchedGameItem = try dbQueue.read { db in
            try SudokuGameItemModel.fetchOne(db)
        }
        
        XCTAssertEqual(
            sut,
            fetchedGameItem,
            "Written gameItem should be equal to the inserted gameItem"
        )
    }
    
    func test_SudokuGameModel_one_to_many_items_association() throws {
        let dbQueue = try makeDbQueue()
        let gameItemsCountToBeInserted = Int.random(in: 2...10)
        var game = SudokuGameModel.testGame
        try dbQueue.write { db in
            try game.insert(db)
            for _ in 0..<gameItemsCountToBeInserted {
                var item = SudokuGameItemModel.testItem(gameId: game.id!)
                try item.insert(db)
            }
        }
        
        let count = try dbQueue.read { db in
            try game.items.fetchCount(db)
        }
        
        XCTAssertEqual(
            count,
            gameItemsCountToBeInserted,
            "Game should have \(gameItemsCountToBeInserted) items"
        )   
    }
    
    // MARK: Helpers
    func makeDbQueue() throws -> DatabaseQueue {
        let dbQueue = try DatabaseQueue()
        let migrator = SudokuDatabaseMigrator()
        try migrator.migrate(dbQueue)
        return dbQueue
    }
}

extension SudokuGameModel {
    static var testGame: SudokuGameModel {
        SudokuGameModel(
            difficulty: .hard,
            time: 10,
            mistakesCount: 0,
            suggestionsCount: 1,
            isSolved: false,
            score: 0
        )
    }
}

extension SudokuGameItemModel {
    static func testItem(gameId: Int64) -> SudokuGameItemModel {
        SudokuGameItemModel(
            gameId: gameId,
            row: 0,
            column: 0,
            correctValue: 1,
            value: nil,
            isEditable: true,
        )
    }
}
