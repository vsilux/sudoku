//
//  GameDataService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 27.04.2025.
//

import Foundation
import GRDB

protocol GameRepository {
    func save(game: inout SudokuGameModel) throws
    func fetchGame(for id: Int64) throws -> SudokuGameModel?
    func fetchUnfinishedGames() throws -> [SudokuGameModel]
    func fetchLatestGame() throws -> SudokuGameModel?
    func delete(game: SudokuGameModel) throws -> Bool
    func updateTime(gameId: Int64, time: Int) throws
}

class SudokuGameRepository: GameRepository {
    private let fetchUnfinishedGamesSQL = "SELECT * FROM sudokuGameModel WHERE isSolved = 0"
    private let fetchLatestGameSQL = "SELECT * FROM sudokuGameModel ORDER BY id DESC LIMIT 1"
    private let databaseQueue: DatabaseQueue
    
    init(databaseQueue: DatabaseQueue) {
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
    
    func fetchUnfinishedGames() throws -> [SudokuGameModel] {
        try databaseQueue.read { db in
            let games = try SudokuGameModel.fetchAll(
                db,
                sql: fetchUnfinishedGamesSQL
            )
            return games
        }
    }
    
    func fetchLatestGame() throws -> SudokuGameModel? {
        try databaseQueue.read { db in
            let game = try SudokuGameModel.fetchOne(
                db,
                sql: fetchLatestGameSQL
            )
            return game
        }
    }
    
    func delete(game: SudokuGameModel) throws -> Bool {
        try databaseQueue.write { db in
            try game.delete(db)
        }
    }
    
    func updateTime(gameId: Int64, time: Int) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: "UPDATE sudokuGameModel SET time = :time WHERE id = :id",
                    arguments: ["time": time, "id": gameId]
                )
        }
    }
}
