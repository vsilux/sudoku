//
//  DatabaseService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import GRDB

protocol SudokuDatabaseService {
    func save(game: inout SudokuGameModel) throws
    func fetchGame(for id: Int64) throws -> SudokuGameModel?
    func remove(game: SudokuGameModel) throws -> Bool
    func save(gameItems: inout [[SudokuGameItemModel]]) throws
    func items(for game: SudokuGameModel) throws -> [[SudokuGameItemModel]]?
    func save(gameItem: inout SudokuGameItemModel) throws
    func fetchGameItem(for id: Int64) throws -> SudokuGameItemModel?
}

class DatabaseService: SudokuDatabaseService {
    private let databaseQueue: DatabaseQueue
    
    init(databaseQueue: DatabaseQueue) throws {
        self.databaseQueue = databaseQueue
    }
    
    func save(game: inout SudokuGameModel) throws {
        try databaseQueue.write { db in
            try game.save(db)
        }
    }
    
    func fetchGame(for id: Int64) throws -> SudokuGameModel? {
        try databaseQueue.read { db in
            try SudokuGameModel.fetchOne(db, key: id)
        }
    }
    
    func remove(game: SudokuGameModel) throws -> Bool {
        try databaseQueue.write { db in
            try game.delete(db)
        }
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
}
