//
//  SudokuGameModel.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import Foundation
import GRDB

public struct SudokuGameModel: Codable {
    public var id: Int64?
    public let difficulty: Difficulty
    public var time: Int
    public var mistakes: Int
    public var hints: Int
    public var isSolved: Bool
    public var score: Int
    
    init(difficulty: Difficulty, time: Int = 0, mistakes: Int = 0, hints: Int = 0, isSolved: Bool = false, score: Int = 0) {
        self.difficulty = difficulty
        self.time = time
        self.mistakes = mistakes
        self.hints = hints
        self.isSolved = isSolved
        self.score = score
    }
}

extension SudokuGameModel: Equatable {
    public static func == (lhs: SudokuGameModel, rhs: SudokuGameModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.difficulty == rhs.difficulty
    }
}

extension SudokuGameModel: FetchableRecord, MutablePersistableRecord {
    static let items = hasMany(SudokuGameItemModel.self)
    var items: QueryInterfaceRequest<SudokuGameItemModel> {
        request(for: SudokuGameModel.items)
    }
    
    public mutating func didInsert(_ inserted: InsertionSuccess) {
        self.id = inserted.rowID
    }
}

extension SudokuGameModel {
    public enum Difficulty: Int, CaseIterable, Codable {
        case easy = 30
        case medium = 40
        case hard = 50
        case expert = 60
        case master = 70
        
        var name: String {
            switch self {
            case .easy: return "Easy"
            case .medium: return "Medium"
            case .hard: return "Hard"
            case .expert: return "Expert"
            case .master: return "Master"
            }
        }
    }
}

extension SudokuGameModel.Difficulty: DatabaseValueConvertible {}
