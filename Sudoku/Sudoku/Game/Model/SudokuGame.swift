//
//  SudokuBoard.swift
//  Sudoku
//
//  Created by Illia Suvorov on 15.04.2025.
//

import Foundation
import Combine

struct SudokuBoard: Codable, Hashable, Identifiable {
    var id: UUID
    var items: [[SudokuBoardItem]]
    var time: TimeInterval
    var mistakesCount: Int
    var suggestionsCount: Int
    var isSolved: Bool
    
    init(id: UUID, items: [[SudokuBoardItem]], time: TimeInterval, mistakesCount: Int, suggestionsCount: Int, isSolved: Bool) {
        self.id = id
        self.items = items
        self.time = time
        self.mistakesCount = mistakesCount
        self.suggestionsCount = suggestionsCount
        self.isSolved = isSolved
    }
    
    init(items: [[SudokuBoardItem]]) {
        self.init(id: UUID(), items: items, time: 0, mistakesCount: 0, suggestionsCount: 1, isSolved: false)
    }
    
    mutating func updateTime(_ time: TimeInterval) {
        self.time = time
    }
    
    mutating func updateMistakesCount(_ count: Int) {
        self.mistakesCount = count
    }
    
    mutating func updateSuggestionsCount(_ count: Int) {
        self.suggestionsCount = count
    }
    
    mutating func sloved() {
        self.isSolved = true
    }
}
