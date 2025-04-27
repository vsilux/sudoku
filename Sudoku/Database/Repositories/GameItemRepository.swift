//
//  DatabaseService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import GRDB

protocol GameItemRepository {
    func save(gameItems: inout [[SudokuGameItemModel]]) throws
    func items(for game: SudokuGameModel) throws -> [[SudokuGameItemModel]]?
    
    func save(gameItem: inout SudokuGameItemModel) throws
    func fetchGameItem(for id: Int64) throws -> SudokuGameItemModel?
    func updateGameItem(id: Int64, value: Int?) throws
}

class SudokuGameItemRepository: GameItemRepository {
    private let databaseQueue: DatabaseQueue
    
    init(databaseQueue: DatabaseQueue) {
        self.databaseQueue = databaseQueue
    }
    
    func save(gameItems: inout [[SudokuGameItemModel]]) throws {
        try databaseQueue.write { db in
            for row in 0..<gameItems.count {
                for column in 0..<gameItems[row].count {
                    try gameItems[row][column].save(db)
                }
            }
        }
    }
    
    func items(for game: SudokuGameModel) throws -> [[SudokuGameItemModel]]? {
        try databaseQueue.read { db in
            let rawItems = try game.items.fetchAll(db)
            guard !rawItems.isEmpty else {
                return nil
            }
            
            let items = rawItems.chopped(SudokuConstants.fildSize)
            return items
        }
    }
    
    func save(gameItem: inout SudokuGameItemModel) throws {
        try databaseQueue.write { db in
            try gameItem.save(db)
        }
    }
    
    func fetchGameItem(for id: Int64) throws -> SudokuGameItemModel? {
        try databaseQueue.read { db in
            try SudokuGameItemModel.fetchOne(db, key: id)
        }
    }
    
    func updateGameItem(id: Int64, value: Int?) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: "UPDATE sudokuGameItemModel SET value = :value WHERE id = :id",
                    arguments: ["value": value, "id": id]
                )
        }
    }
}
    
