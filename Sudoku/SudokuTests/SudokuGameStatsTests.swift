//
//  SudokuGameStatsTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 17.04.2025.
//

import XCTest
@testable import Sudoku

final class SudokuGameStatsTests: XCTestCase {

    func test_gameStatsStoryboardInitialViewController_isGameStatsViewController() {
        let storyboard = UIStoryboard(name: "GameStats", bundle: nil)
        XCTAssertTrue(storyboard.instantiateInitialViewController() is GameStatsViewController)
    }
}
