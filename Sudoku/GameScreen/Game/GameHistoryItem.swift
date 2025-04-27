//
//  GameHistoryItem.swift
//  Sudoku
//
//  Created by Illia Suvorov on 21.04.2025.
//

import Foundation

struct GameHistoryItem {
    let id: Int64
    let row: Int
    let column: Int
    let previousValue: Int?
}
