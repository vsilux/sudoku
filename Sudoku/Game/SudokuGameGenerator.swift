//
//  GameGenerator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import Foundation

class SudokuGameGenerator {
    func generateBoard(difficulty: SudokuGame.Difficulty) -> SudokuGame {
        var items: [[SudokuGameItem]] = Array(repeating: Array(repeating: SudokuGameItem(id: .init(row: 0, column: 0), correctValue: 0, value: nil, isEditable: true), count: SudokuConstants.fildSize), count: SudokuConstants.fildSize)
        
        // Fill the diagonal 3x3 boxes
        for i in stride(from: 0, to: SudokuConstants.fildSize, by: 3) {
            fillDiagonalBox(startRow: i, startColumn: i, items: &items)
        }
        
        // Fill the remaining cells
        _ = fillRemainingCells(row: 0, column: 3, items: &items)
        
        // Remove cells based on difficulty
        removeCellsForDifficulty(difficulty: difficulty, items: &items)
        
        return SudokuGame(difficulty: difficulty, items: items)
    }
    
    private func fillDiagonalBox(startRow: Int, startColumn: Int, items: inout [[SudokuGameItem]]) {
        var numbers = Array(1...SudokuConstants.fildSize).shuffled()
        for i in 0..<3 {
            for j in 0..<3 {
                let index = SudokuGameItem.Index(row: startRow + i, column: startColumn + j)
                let value = numbers.removeFirst()
                items[startRow + i][startColumn + j] = SudokuGameItem(id: index, correctValue: value, value: value, isEditable: false)
            }
        }
    }
    
    private func fillRemainingCells(row: Int, column: Int, items: inout [[SudokuGameItem]]) -> Bool {
        if row >= SudokuConstants.fildSize {
            return true
        }
        
        let nextRow = column >= SudokuConstants.fildSize - 1 ? row + 1 : row
        let nextColumn = column >= SudokuConstants.fildSize - 1 ? 0 : column + 1
        
        if items[row][column].correctValue != 0 {
            return fillRemainingCells(row: nextRow, column: nextColumn, items: &items)
        }
        
        for num in 1...SudokuConstants.fildSize {
            if isSafeToPlace(row: row, column: column, num: num, items: items) {
                let index = SudokuGameItem.Index(row: row, column: column)
                items[row][column] = SudokuGameItem(id: index, correctValue: num, value: num, isEditable: false)
                if fillRemainingCells(row: nextRow, column: nextColumn, items: &items) {
                    return true
                }
                items[row][column] = SudokuGameItem(id: index, correctValue: 0, value: nil, isEditable: true)
            }
        }
        
        return false
    }
    
    private func isSafeToPlace(row: Int, column: Int, num: Int, items: [[SudokuGameItem]]) -> Bool {
        for i in 0..<SudokuConstants.fildSize {
            if items[row][i].correctValue == num || items[i][column].correctValue == num {
                return false
            }
        }
        
        let startRow = row / 3 * 3
        let startColumn = column / 3 * 3
        for i in 0..<3 {
            for j in 0..<3 {
                if items[startRow + i][startColumn + j].correctValue == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func removeCellsForDifficulty(difficulty: SudokuGame.Difficulty, items: inout [[SudokuGameItem]]) {
        let cellsToRemove = difficulty.rawValue
        var removed = 0
        
        while removed < cellsToRemove {
            let row = Int.random(in: 0..<SudokuConstants.fildSize)
            let column = Int.random(in: 0..<SudokuConstants.fildSize)
            
            if items[row][column].value != nil {
                items[row][column].value = nil
                items[row][column].isEditable = true
                removed += 1
            }
        }
    }
}
