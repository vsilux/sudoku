//
//  GameController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import Foundation

class GameController: SudokuBoardConentDataSource, NumpadInterectionHandler {
    private let game: SudokuGame
    
    init(game: SudokuGame) {
        self.game = game
    }
    
    func itemFor(row: Int, column: Int) -> SudokuBoardItem {
        self.game.items[row][column]
    }
    
    func didTap(number: Int) {
        
    }
}

extension SudokuGameItem: SudokuBoardItem {
    var row: Int {
        return id.row
    }
    
    var column: Int {
        return id.column
    }
    
    var isCorrect: Bool {
        return correctValue == (value ?? correctValue)
    }
    
    
}
