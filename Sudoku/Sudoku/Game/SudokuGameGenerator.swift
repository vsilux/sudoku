//
//  GameGenerator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import Foundation

class SudokuGameGenerator {
    func generateBoard(size: Int = 9) -> SudokuBoard {
        var items: [[SudokuBoardItem]] = []
        
        for row in 0..<size {
            var rowItems: [SudokuBoardItem] = []
            for column in 0..<size {
                let index = SudokuBoardItem.Index(row: row, column: column)
                let correctValue = (row * 3 + row / 3 + column) % size + 1 // Example logic for generating values
                let isEditable = Bool.random() // Randomly decide if the cell is editable
                let item = SudokuBoardItem(id: index, correctValue: correctValue, value: isEditable ? nil : correctValue, isEditable: isEditable)
                rowItems.append(item)
            }
            items.append(rowItems)
        }
        
        return SudokuBoard(items: items)
    }
}
