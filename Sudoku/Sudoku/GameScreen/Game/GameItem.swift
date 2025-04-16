//
//  GameItem.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation

struct GameItem: SudokuBoardItem {
    var id: SudokuGameItem.Index
    var correctValue: Int
    var value: Int?
    var isEditable: Bool
    var row: Int { id.row }
    var column: Int { id.column }
    var isCorrect: Bool { value == nil || value == correctValue }
    var state: SudokuItemState
    
    init(
        id: SudokuGameItem.Index,
        correctValue: Int,
        value: Int? = nil,
        isEditable: Bool,
        state: SudokuItemState
    ) {
        self.id = id
        self.correctValue = correctValue
        self.value = value
        self.isEditable = isEditable
        self.state = state
    }
    
    init(sudokuItem: SudokuGameItem) {
        self.id = sudokuItem.id
        self.correctValue = sudokuItem.correctValue
        self.value = sudokuItem.value
        self.isEditable = sudokuItem.isEditable
        self.state = .normal // Default state, can be changed later
    }
}
