//
//  BoardIndex.swift
//  Sudoku
//
//  Created by Illia Suvorov on 01.05.2025.
//

import Foundation

struct GameBoardIndex: Hashable {
    var row: Int
    var column: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}
