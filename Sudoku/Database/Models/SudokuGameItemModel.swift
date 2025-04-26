//
//  SudokuGameItemModel.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import Foundation
import GRDB

struct SudokuGameItemModel: Codable {
    var id: Int64?
    var gameId: Int64
    var row: Int
    var column: Int
    var correctValue: Int
    var value: Int?
    var isEditable: Bool
    
    static var invalid: SudokuGameItemModel {
        SudokuGameItemModel(gameId: -1, row: -1, column: -1, correctValue: 0, isEditable: false)
    }
    
    static func empty(gameId: Int64) -> SudokuGameItemModel {
        SudokuGameItemModel(gameId: gameId, row: -1, column: -1, correctValue: 0, isEditable: false)
    }
}

extension SudokuGameItemModel: Equatable {
    static func == (lhs: SudokuGameItemModel, rhs: SudokuGameItemModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.gameId == rhs.gameId &&
        lhs.row == rhs.row &&
        lhs.column == rhs.column &&
        lhs.correctValue == rhs.correctValue
    }
}

extension SudokuGameItemModel: FetchableRecord, MutablePersistableRecord {
    static let game = belongsTo(SudokuGameModel.self)
    var game: QueryInterfaceRequest<SudokuGameModel> {
        return request(for: SudokuGameItemModel.game)
    }
    
    mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }
}
