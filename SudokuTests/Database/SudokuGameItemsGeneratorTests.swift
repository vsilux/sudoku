//
//  SudokuGameModelGeneratorTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 25.04.2025.
//

import XCTest
@testable import Sudoku

final class SudokuGameItemsGeneratorTests: XCTestCase {
    func test_SudokuGameItemGenerator_generateGameItems() throws {
        var game = SudokuGameModel.testGame
        game.id = Int64.max
        
        let sut = SudokuGameItemsGenerator()
        let gameItems = try sut.generateGameItems(for: game)
        
        XCTAssertEqual(
            gameItems.reduce(0, { partialResult, row in
                (partialResult + row.count)
            }), SudokuConstants.fildSize * SudokuConstants.fildSize,
            "The number of generated game items should match the Sudoku field size."
        )
        
        XCTAssertEqual(
            gameItems.reduce(
                0, { partialResult, row in
                    partialResult + row
                        .reduce(0, { $0 + ($1.value == nil ? 1 : 0) })
                }
            ),
            game.difficulty.rawValue,
            "The number of empty game items should match the Sudoku field size."
        )
    }
}
