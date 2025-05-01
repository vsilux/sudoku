//
//  GameBoardStateUpdater.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation

enum GameBoardStateHelper {
    typealias Index = GameBoardIndex
    
    static func hilightCross(in items: inout [[GameItem]], selectedItemIndex: Index?) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        
        // Hilight selected row
        for column in 0..<SudokuConstants.fildSize {
            if column != selectedItemIndex.column {
                items[selectedItemIndex.row][column].state = .subtleHighlight
            }
        }
        
        for row in 0..<SudokuConstants.fildSize {
            if row != selectedItemIndex.row {
                items[row][selectedItemIndex.column].state = .subtleHighlight
            }
        }
    }
    
    static func hilightSame(in items: inout [[GameItem]], selectedItemIndex: Index?) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        
        let selectedValue = items[selectedItemIndex.row][selectedItemIndex.column].value
        for row in 0..<SudokuConstants.fildSize {
            for column in 0..<SudokuConstants.fildSize {
                let item = items[row][column]
                if item.value != nil &&
                    item.value == selectedValue &&
                    item.state != .selected {
                    items[row][column].state = .highlight
                }
            }
        }
    }
    
    static func cleanup(in items: inout [[GameItem]]) {
        for row in 0..<items.count {
            for column in 0..<items[row].count {
                if items[row][column].state != .normal {
                    items[row][column].state = .normal
                }
            }
        }
    }
    
    static func hilightBlock(in items: inout [[GameItem]], selectedItemIndex: Index?) {
        guard let selectedItemIndex = selectedItemIndex else {
            return
        }
        
        let (verticalBlockIndex, horizontalBlockIndex) = block(for: selectedItemIndex)
        
        let rowStartIndex = verticalBlockIndex * SudokuConstants.fildBlocSize
        let columnStartIndex = horizontalBlockIndex * SudokuConstants.fildBlocSize
        for row in rowStartIndex..<(
            rowStartIndex + SudokuConstants.fildBlocSize
        ) {
            for column in columnStartIndex..<(
                columnStartIndex + SudokuConstants.fildBlocSize
            ) {
                if items[row][column].state == .normal {
                    items[row][column].state = .subtleHighlight
                }
            }
        }
    }
    
    private static func block(for selectedItemIndex: Index) -> (verticalBlockIndex: Int, horizontalBlockIndex: Int) {
        let verticalIndex = selectedItemIndex.row / SudokuConstants.fildBlocSize
        let horizontalIndex = selectedItemIndex.column / SudokuConstants.fildBlocSize
        
        return (verticalIndex, horizontalIndex)
    }
}
