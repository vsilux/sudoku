//
//  GameScreenTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 12.04.2025.
//

import XCTest
@testable import Sudoku

final class GameScreenTests: XCTestCase {

    let storyboard = UIStoryboard(name: "GameScreen", bundle: nil)
    
    func test_GameScreenStoryboardInitialViewController_isGameViewController() {
        XCTAssertTrue(storyboard.instantiateInitialViewController() is GameViewController)
    }
    
    func test_GameViewController_collectionViewNotNull() {
        let sut = storyboard.instantiateInitialViewController() as! GameViewController
        
        XCTAssertNotNil(sut.collectionView)
    }

}
