//
//  PauseScreenTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 22.04.2025.
//

import XCTest
@testable import Sudoku

final class PauseScreenTests: XCTestCase {

    let storybard = UIStoryboard(name: "PauseScreen", bundle: nil)
    
    func test_PauseScreenStoryBoard_initialViewControlller_isPauseViewController() {
        let viewController = storybard.instantiateInitialViewController()
        XCTAssertTrue(viewController is PauseViewController, "Initial view controller should be of type PauseViewController")
    }
    
    func test_PauseViewController_OuletsIsNotNil() {
        let sut = makeSUT()
        
        _ = sut.view // Load the view
        
        XCTAssertNotNil(sut.containerView, "Container view should not be nil after loading")
        XCTAssertNotNil(sut.difficultyLabel, "Difficulty label should not be nil after loading")
        XCTAssertNotNil(sut.mistakesCountLabel, "Mistakes count label should not be nil after loading")
        XCTAssertNotNil(sut.timeLabel, "Time label should not be nil after loading")
        XCTAssertNotNil(sut.scoreLabel, "Score label should not be nil after loading")
    }
    
    // MARK: Helpers
    func makeSUT() -> PauseViewController {
        storybard.instantiateInitialViewController() as! PauseViewController
    }
}
