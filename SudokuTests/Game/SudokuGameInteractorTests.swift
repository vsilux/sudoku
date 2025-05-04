//
//  GameInteractorTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 04.05.2025.
//

import XCTest
import Combine
@testable import Sudoku

final class SudokuGameInteractorTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    func test_SudokuGameInteractor_update_item() {
        let (sut, game, repository) = makeSUT()
        
        let time = 102132
        
        let expectation = XCTestExpectation(description: "Game time should be updated")
        let expectedValues = [game.time, time]
        var recevedValues = [Int]()
        sut.gamePublisher.sink { updatedGame in
            recevedValues.append(updatedGame.time)
            if recevedValues.count == expectedValues.count {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.update(time: time)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(
            recevedValues,
            expectedValues,
            "Game time should be updated in the interactor"
        )
        
        let lastAction = repository.actions.last
        switch lastAction {
        case .updateTime(let updatedTime, _):
            XCTAssertEqual(
                updatedTime,
                time,
                "Invalid game time updated for repository"
            )
        default:
            XCTFail("Invalid action in repository")
        }
    }
    
    func test_SudokuGameInteractor_update_mistakes() {
        let (sut, game, repository) = makeSUT()
        
        let mistakes = 3
        
        let expectation = XCTestExpectation(description: "Game mistakes should be updated")
        let expectedValues = [game.mistakes, mistakes]
        var recevedValues = [Int]()
        
        sut.gamePublisher.sink { updatedGame in
            recevedValues.append(updatedGame.mistakes)
            if recevedValues.count == expectedValues.count {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.update(mistakesCount: mistakes)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(
            recevedValues,
            expectedValues,
            "Game mistakes should be updated in the interactor"
        )
        
        let lastAction = repository.actions.last
        switch lastAction {
        case .updateMistakes(let updatedMistakes, _):
            XCTAssertEqual(
                updatedMistakes,
                mistakes,
                "Invalid game mistakes updated for repository"
            )
        default:
            XCTFail("Invalid action in repository")
        }
    }

    func test_SudokuGameInteractor_update_score() {
        let (sut, game, repository) = makeSUT()
        
        let score = 12312
        
        let expectation = XCTestExpectation(description: "Game score should be updated")
        let expectedValues = [game.score, score]
        var recevedValues = [Int]()
        
        sut.gamePublisher.sink { updatedGame in
            recevedValues.append(updatedGame.score)
            if recevedValues.count == expectedValues.count {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.update(score: score)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(
            recevedValues,
            expectedValues,
            "Game score should be updated in the interactor"
        )
        
        let lastAction = repository.actions.last
        switch lastAction {
        case .updateScore(let updatedScore, _):
            XCTAssertEqual(
                updatedScore,
                score,
                "Invalid game score updated for repository"
            )
        default:
            XCTFail("Invalid action in repository")
        }
    }
    
    func makeSUT() -> (sut: SudokuGameInteractor, game: SudokuGameModel, repository: MockGameRepository) {
        var game = SudokuGameModel.testGame
        let repository = MockGameRepository()
        try? repository.save(game: &game)
        return (SudokuGameInteractor(game: game, repository: repository), game, repository)
    }

}
