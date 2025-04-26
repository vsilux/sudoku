//
//  SudokuGameModelGenerator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import Foundation

protocol GameItemsGenerator {
    func generateGameItems(for gameModel: SudokuGameModel) -> [[SudokuGameItemModel]]?
}

class SudokuGameItemsGenerator: GameItemsGenerator {
    enum Error: Swift.Error {
        case gameIdIsNil
    }
    
    func generateGameItems(for gameModel: SudokuGameModel) -> [[SudokuGameItemModel]]? {
        guard let gameId = gameModel.id else {
            return nil
        }
        
        var items: [[SudokuGameItemModel]] = Array(
            repeating: Array(
                repeating: SudokuGameItemModel.invalid,
                count: SudokuConstants.fildSize
            ),
            count: SudokuConstants.fildSize
        )
        
        fillDiagonal(items: &items, gameId: gameId)
            
        _ = fillRemainingCells(row: 0, column: 3, gameId: gameId, items: &items)
            
        wipeCellsForDifficulty(difficulty: gameModel.difficulty, items: &items)
        
        return items
    }
    
    private func fillDiagonal(
        items: inout [[SudokuGameItemModel]],
        gameId: Int64
    ) {
        for diagonalBox in 0..<3 {
            let startRow = diagonalBox * 3
            let startColumn = diagonalBox * 3
            var numbers = Array(1...SudokuConstants.fildSize).shuffled()
            
            for i in 0..<3 {
                for j in 0..<3 {
                    let value = numbers.removeFirst()
                    items[startRow + i][startColumn + j] = SudokuGameItemModel(
                        gameId: gameId,
                        row: startRow + i,
                        column: startColumn + j,
                        correctValue: value,
                        value: value,
                        isEditable: false
                    )
                }
            }
        }
    }
    
    private func fillRemainingCells(row: Int, column: Int, gameId: Int64, items: inout [[SudokuGameItemModel]]) -> Bool {
        if row >= SudokuConstants.fildSize {
            return true
        }
        
        let nextRow = column >= SudokuConstants.fildSize - 1 ? row + 1 : row
        let nextColumn = column >= SudokuConstants.fildSize - 1 ? 0 : column + 1
        
        if items[row][column].correctValue != 0 {
            return fillRemainingCells(row: nextRow, column: nextColumn, gameId: gameId, items: &items)
        }
        
        for num in 1...SudokuConstants.fildSize {
            if isSafeToPlace(row: row, column: column, num: num, items: items) {
                items[row][column] = SudokuGameItemModel(gameId: gameId, row: row, column: column, correctValue: num, value: num, isEditable: false)
                if fillRemainingCells(row: nextRow, column: nextColumn, gameId: gameId, items: &items) {
                    return true
                }
                items[row][column] = SudokuGameItemModel(gameId: gameId, row: row, column: column, correctValue: 0, value: nil, isEditable: true)
            }
        }
        
        return false
    }
    
    private func isSafeToPlace(row: Int, column: Int, num: Int, items: [[SudokuGameItemModel]]) -> Bool {
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
    
    private func wipeCellsForDifficulty(
        difficulty: SudokuGameModel.Difficulty,
        items: inout [[SudokuGameItemModel]]
    ) {
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
