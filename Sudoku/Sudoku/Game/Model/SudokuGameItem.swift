//
//  BoardItem.swift
//  Sudoku
//
//  Created by Illia Suvorov on 15.04.2025.
//

import Foundation

struct SudokuBoardItem: Codable, Hashable, Identifiable {
    var id: Index
    var correctValue: Int
    var value: Int?
    var isEditable: Bool
}

extension SudokuBoardItem {
    struct Index: Codable, Hashable, Equatable {
        var row: Int
        var column: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(row)
            hasher.combine(column)
        }
        
        static func == (lhs: Index, rhs: Index) -> Bool {
            return lhs.row == rhs.row && lhs.column == rhs.column
        }
    }
}

