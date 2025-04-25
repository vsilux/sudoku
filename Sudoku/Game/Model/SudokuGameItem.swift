//
//  BoardItem.swift
//  Sudoku
//
//  Created by Illia Suvorov on 15.04.2025.
//

import Foundation

struct SudokuGameItem: Identifiable {
    var id: Int64?
    var row: Int
    var column: Int
    var correctValue: Int
    var value: Int?
    var isEditable: Bool
    
    static var invalid: SudokuGameItem {
        SudokuGameItem(
            row: -1,
            column: -1,
            correctValue: 0,
            value: nil,
            isEditable: true
        )
    }
}

extension SudokuGameItem: Codable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.row == rhs.row &&
        lhs.column == rhs.column &&
        lhs.correctValue == rhs.correctValue
    }
}
