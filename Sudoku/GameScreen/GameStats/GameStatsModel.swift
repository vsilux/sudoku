//
//  GameStats.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import Foundation

protocol GameStats {
    var difficulty: String { get }
    var mistakesCount: Int { get }
    var time: Int { get }
    var score: Int { get }
    var maxScore: Int { get }
}

struct GameStatsModel: GameStats {
    var difficulty: String
    var mistakesCount: Int
    var time: Int
    var score: Int
    var maxScore: Int
}
