//
//  GameItem.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation

struct GameItem: SudokuBoardItem {
    var id: Int64
    var row: Int
    var column: Int
    var correctValue: Int
    var value: Int?
    var isEditable: Bool
    var isCorrect: Bool { value == nil || value == correctValue }
    var state: SudokuItemState
    
    init(model: SudokuGameItemModel) {
        id = model.id ?? -1
        row = model.row
        column = model.column
        correctValue = model.correctValue
        value = model.value
        isEditable = model.isEditable
        state = .normal // Default state, can be changed later
    }
}
