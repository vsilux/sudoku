//
//  MainMenuTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 24.04.2025.
//

import XCTest
@testable import Sudoku

final class MainMenuTests: XCTestCase {

    let storyboard = UIStoryboard(name: "MainMenu", bundle: nil)
    
    func test_MainMenuStoryboard_initialViewController_isMainMenuViewController() {
        let initialViewController = storyboard.instantiateInitialViewController()
        XCTAssertTrue(initialViewController is MainMenuViewController, "Initial view controller should be MainMenuViewController")
    }
    
    func test_MainMenuViewController_nuttons_isAdded() {
        let sut = makeSUT()
        
        _ = sut.view
        
        XCTAssertNotNil(sut.newGameButton, "New Game button should be added")
        XCTAssertNotNil(sut.continueGameButton, "Continue Game button should be added")
    }
    
    // MARK: - Helper Methods
    func makeSUT() -> MainMenuViewController {
        storyboard.instantiateInitialViewController() as! MainMenuViewController
    }
}
