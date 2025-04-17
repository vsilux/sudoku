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
        let dataProvider = MockGameStatsDataProvider()
        let sut = makeSUT()
        sut.dataProvider = dataProvider
        
        _ = sut.view
        XCTAssertEqual(sut.maxScoreLabel?.text, "12 305")
        XCTAssertEqual(sut.difficultyLabel?.text, "hard")
        XCTAssertEqual(sut.mistakesLabel?.text, "0/3")
        XCTAssertEqual(sut.timeLabel?.text, "02:02")
    }
    
    func test_gameStatsViewController_isUpdatingTimeLabel() {
        let dataProvider = MockGameStatsDataProvider()
        let sut = makeSUT()
        sut.dataProvider = dataProvider
        
        _ = sut.view
        XCTAssertEqual(sut.timeLabel?.text, "02:02")
        dataProvider.incrementTime()
        XCTAssertEqual(sut.timeLabel?.text, "02:03")
    }
    
    func test_gameStatsViewController_isUpdatingMistakesLabel() {
        let dataProvider = MockGameStatsDataProvider()
        let sut = makeSUT()
        sut.dataProvider = dataProvider
        
        _ = sut.view
        XCTAssertEqual(sut.mistakesLabel?.text, "0/3")
        dataProvider.incrementMistakes()
        XCTAssertEqual(sut.mistakesLabel?.text, "1/3")
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> GameStatsViewController {
        return storyboard.instantiateInitialViewController() as! GameStatsViewController
    }
    
    // MARK: - Mocks
    
    class MockGameStatsDataProvider: GameStatsDataProvider {
        @Published private var seconds: Int = 122
        @Published private var mistakesCount: Int = 0
        
        func maxScore() -> Int {
            12305
        }
        
        func difficulty() -> String {
            "hard"
        }
        
        func mistakes() -> AnyPublisher<Int, Never> {
            $mistakesCount.eraseToAnyPublisher()
        }
        
        func time() -> AnyPublisher<Int, Never> {
            $seconds.eraseToAnyPublisher()
        }
        
        func incrementTime() {
            seconds += 1
        }
        
        func incrementMistakes() {
            mistakesCount += 1
        }
    }
}
