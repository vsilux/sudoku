//
//  StartupScreenTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 10.04.2025.
//

import XCTest
@testable import Sudoku

final class StartupScreenTests: XCTestCase {

    let storyboard = UIStoryboard(name: "StartupScreen", bundle: nil)

    func test_startupScreenStoryboardInitialViewController_isStartupViewController() {
        XCTAssertTrue(storyboard.instantiateInitialViewController() is StartupViewController)
    }
    
    func test_startupViewController_hasGameInProgressProvider() {
        
    }
    
    
}
