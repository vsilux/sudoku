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
    
    func update(time: Int, for gameId: Int64) throws
    func update(mistakes: Int, for gameId: Int64) throws
    func update(hints: Int, for gameId: Int64) throws
    func update(score: Int, for gameId: Int64) throws
}

class SudokuGameRepository: GameRepository {
    enum SQLQuery: String {
        case fetchUnfinishedGames = "SELECT * FROM sudokuGameModel WHERE isSolved = 0"
        case fetchLatestGame = "SELECT * FROM sudokuGameModel ORDER BY id DESC LIMIT 1"
        case updateTime = "UPDATE sudokuGameModel SET time = :time WHERE id = :id"
        case updateMistakes = "UPDATE sudokuGameModel SET mistakes = :mistakes WHERE id = :id"
        case updateHints = "UPDATE sudokuGameModel SET hints = :hints WHERE id = :id"
        case updateScore = "UPDATE sudokuGameModel SET score = :score WHERE id = :id"
    }
    
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
                sql: SQLQuery.fetchUnfinishedGames.rawValue
            )
            return games
        }
    }
    
    func fetchLatestGame() throws -> SudokuGameModel? {
        try databaseQueue.read { db in
            let game = try SudokuGameModel.fetchOne(
                db,
                sql: SQLQuery.fetchLatestGame.rawValue
            )
            return game
        }
    }
    
    func delete(game: SudokuGameModel) throws -> Bool {
        try databaseQueue.write { db in
            try game.delete(db)
        }
    }
    
    func update(time: Int, for gameId: Int64) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: SQLQuery.updateTime.rawValue,
                    arguments: ["time": time, "id": gameId]
                )
        }
    }
    
    func update(mistakes: Int, for gameId: Int64) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: SQLQuery.updateMistakes.rawValue,
                    arguments: ["mistakes": mistakes, "id": gameId]
                )
        }
    }
    
    func update(hints: Int, for gameId: Int64) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: SQLQuery.updateHints.rawValue,
                    arguments: ["hints": hints, "id": gameId]
                )
        }
    }
    
    func update(score: Int, for gameId: Int64) throws {
        try databaseQueue.write { db in
            try db
                .execute(
                    sql: SQLQuery.updateScore.rawValue,
                    arguments: ["score": score, "id": gameId]
                )
        }
    }
}
