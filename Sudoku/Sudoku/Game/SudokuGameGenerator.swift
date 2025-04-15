//
//  GameGenerator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import Foundation

class SudokuGameGenerator {
    func generateBoard(size: Int = 9) -> SudokuGame {
        var items: [[SudokuGameItem]] = []
        
        for row in 0..<size {
            var rowItems: [SudokuGameItem] = []
            for column in 0..<size {
                let index = SudokuGameItem.Index(row: row, column: column)
                let correctValue = (row * 3 + row / 3 + column) % size + 1 // Example logic for generating values
                let isEditable = Bool.random() // Randomly decide if the cell is editable
                let item = SudokuGameItem(id: index, correctValue: correctValue, value: isEditable ? nil : correctValue, isEditable: isEditable)
                rowItems.append(item)
            }
            items.append(rowItems)
        }
        
        return SudokuGame(items: items)
    }
}
