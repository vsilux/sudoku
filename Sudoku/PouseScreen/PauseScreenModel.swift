//
//  PauseScreenModel.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import Foundation

struct PauseScreenModel {
    let difficulty: String
    let mistakesCount: Int
    let time: Int
    let score: Int
    let resumeAction: () -> Void
}
