//
//  SudokuBoardSizeProvider.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import Foundation

protocol SudokuBoardSizeProvider {
    var screenWidth: Double { get }
    var cellSize: Double { get }
    var realContentWidth: Double { get }
    var additionalPadding: Double { get }
    var largeOffset: Double { get }
    var smallOffset: Double { get }
}

struct SudokuBoardScreenBasedSizeProvider: SudokuBoardSizeProvider {
    var screenWidth: Double
    var cellSize: Double
    var realContentWidth: Double
    var additionalPadding: Double
    var largeOffset: Double
    var smallOffset: Double
    
    let minimumContentMargin: CGFloat = 8.0
    
    init(screenWidth: Double) {
        self.screenWidth = screenWidth
        
        let rawContentWidth = screenWidth - minimumContentMargin * 2.0
        
        largeOffset = SudokuConstants.largeOffset
        smallOffset = SudokuConstants.smallOffset
        
        let totalOffsets = SudokuConstants.smallOffsetsCount * smallOffset + SudokuConstants.largeOffsetsCount * largeOffset
        cellSize = CGFloat(Int((rawContentWidth - totalOffsets) / CGFloat(SudokuConstants.fildSize)))
        realContentWidth = cellSize * CGFloat(SudokuConstants.fildSize) + totalOffsets
        additionalPadding = minimumContentMargin + (rawContentWidth - realContentWidth) / 2
    }
}
