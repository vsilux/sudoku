//
//  GameStatsMoked.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 24.04.2025.
//

import Combine
@testable import Sudoku

extension SudokuGameStatsTests {
    class MockGameStatsDataProvider: GameStatsDataProvider {
        var timeCounter: any Sudoku.GameTimeCounter
        @Published private var mistakesCount: Int = 0
        
        init(timeCounter: any Sudoku.GameTimeCounter = MockGameTimeCounter()) {
            self.timeCounter = timeCounter
        }
        
        func gameStats() -> any Sudoku.GameStats {
            MockedGameStats(difficulty: difficulty(), mistakesCount: mistakesCount, time: timeCounter.currentTime(), score: 0, maxScore: maxScore())
        }
        
        func maxScore() -> Int {
            12305
        }
        
        func difficulty() -> String {
            "hard"
        }
        
        func mistakes() -> AnyPublisher<Int, Never> {
            $mistakesCount.eraseToAnyPublisher()
        }
        
        func incrementMistakes() {
            mistakesCount += 1
        }
    }
    
    class MockGameTimeCounter: GameTimeCounter {
        @Published private var seconds: Int = 122
        private var isStarted = false
        
        func time() -> AnyPublisher<Int, Never> {
            $seconds.eraseToAnyPublisher()
        }
        
        private(set) var isPoused = false
        func resumeGame() { isPoused = false }
        func pauseGame() { isPoused = true }
        
        func incrementTime() {
            seconds += 1
        }
        
        func startGame() {
            isStarted = true
        }
        
        func stopGame() {
            isStarted = false
        }
        
        func currentTime() -> Int {
            seconds
        }
    }
    
    class MockedRouter: GameStatsNavigationRouter {
        func showPauseScreen(gameStats: any Sudoku.GameStats, resumeAction: @escaping () -> Void) {
            resumeAction()
        }
    }
    
    struct MockedGameStats: GameStats {
        var difficulty: String
        var mistakesCount: Int
        var time: Int
        var score: Int
        var maxScore: Int
    }
}
