//
//  SudokuGameStatsTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 17.04.2025.
//

import XCTest
import Combine
@testable import Sudoku

final class SudokuGameStatsTests: XCTestCase {
    let storyboard = UIStoryboard(name: "GameStats", bundle: nil)
    
    func test_gameStatsStoryboardInitialViewController_isGameStatsViewController() {
        XCTAssertTrue(
            storyboard
                .instantiateInitialViewController() is GameStatsViewController
        )
    }
    
    func test_gameStatsViewController_usesGameStatsDataProvider() {
        let sut = makeSUT(dataProvider: makeDataProvider())
        
        _ = sut.view
        XCTAssertEqual(sut.maxScoreLabel?.text, "12 305")
        XCTAssertEqual(sut.difficultyLabel?.text, "hard")
        XCTAssertEqual(sut.mistakesLabel?.text, "0/3")
        XCTAssertEqual(sut.timeLabel?.text, "02:02")
    }
    
    func test_gameStatsViewController_isUpdatingTimeLabel() {
        let timeCounter = MockGameTimeCounter()
        let sut = makeSUT(dataProvider: makeDataProvider(timeCounter: timeCounter))
        
        _ = sut.view
        XCTAssertEqual(sut.timeLabel?.text, "02:02")
        timeCounter.incrementTime()
        XCTAssertEqual(sut.timeLabel?.text, "02:03")
    }
    
    func test_gameStatsViewController_isUpdatingMistakesLabel() {
        let dataProvider = MockGameStatsDataProvider()
        let sut = makeSUT(dataProvider: dataProvider)
        
        _ = sut.view
        XCTAssertEqual(sut.mistakesLabel?.text, "0/3")
        dataProvider.incrementMistakes()
        XCTAssertEqual(sut.mistakesLabel?.text, "1/3")
    }
    
    // MARK: - Helpers
    
    func makeDataProvider(timeCounter: GameTimeCounter = MockGameTimeCounter()) -> GameStatsDataProvider {
        MockGameStatsDataProvider(timeCounter: timeCounter)
    }
    
    func makeSUT(
        dataProvider: GameStatsDataProvider,
    ) -> GameStatsViewController {
        return GameStatsViewController.make(with: dataProvider, router: MockedRouter())
    }
}
