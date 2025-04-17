//
//  SudokuBoard.swift
//  Sudoku
//
//  Created by Illia Suvorov on 15.04.2025.
//

import Foundation
import Combine

final class SudokuGame: Codable, Hashable, Identifiable {
    let id: UUID
    let difficulty: Difficulty
    private(set) var items: [[SudokuGameItem]]
    private(set) var time: TimeInterval
    private(set) var mistakesCount: Int
    private(set) var suggestionsCount: Int
    private(set) var isSolved: Bool
    
    init(
        id: UUID = UUID(),
        difficulty: Difficulty = .easy,
        items: [[SudokuGameItem]],
        time: TimeInterval = 0.0,
        mistakesCount: Int = 0,
        suggestionsCount: Int = 1,
        isSolved: Bool = false
    ) {
        self.id = id
        self.difficulty = difficulty
        self.items = items
        self.time = time
        self.mistakesCount = mistakesCount
        self.suggestionsCount = suggestionsCount
        self.isSolved = isSolved
    }
    
    func updateTime(_ time: TimeInterval) {
        self.time = time
    }
    
    func updateMistakesCount(_ count: Int) {
        self.mistakesCount = count
    }
    
    func updateSuggestionsCount(_ count: Int) {
        self.suggestionsCount = count
    }
    
    func sloved() {
        self.isSolved = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SudokuGame, rhs: SudokuGame) -> Bool {
        lhs.id == rhs.id
    }
}

extension SudokuGame {
    enum Difficulty: Int, Codable {
        case easy = 30
        case medium = 40
        case hard = 50
        case expert = 60
        case master = 70
    }
}

