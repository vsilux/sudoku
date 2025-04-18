//
//  SudokuGameActionsTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 18.04.2025.
//

import XCTest
@testable import Sudoku

final class SudokuGameActionsTests: XCTestCase {

    let storyboard = UIStoryboard(name: "GameActions", bundle: nil)
    
    func test_GameActionsStoryboard_initialViewController_isGameActionsViewController() {
        XCTAssertTrue(storyboard.instantiateInitialViewController() is GameActionsViewController)
    }
    
    // MARK: - Helpers
    

}
