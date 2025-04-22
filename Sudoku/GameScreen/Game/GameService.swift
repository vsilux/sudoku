//
//  GameService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation
import Combine

protocol GameNavigationRouter {
    func showPauseScreen(dificulty: String, mistakesCount: Int, time: Int)
}

class GameService: SudokuBoardConentDataSource, SudokuBoardInteractionHandler {
    private let game: SudokuGame
    private let router: GameNavigationRouter
    private var selectedItemIndex: SudokuGameItem.Index?
    private var timer: Timer?
    private var gameHistory: [GameHistoryItem] = []
    @Published private var finishedNumbers = Array(repeating: false, count: SudokuConstants.fildSize)
    @Published private var gameItems: [[GameItem]] = []
    @Published private var mistakesCount: Int = 0
    @Published private var inGameTime: Int = 0
    
    init(game: SudokuGame, router: GameNavigationRouter) {
        self.game = game
        self.router = router
        self.gameItems = game.items
            .map { row in row.map { GameItem(sudokuItem: $0) } }
    }
    
    func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never> {
        $gameItems
            .map { $0[row][column] }
            .eraseToAnyPublisher()
    }
    
    func selectedItemAt(row: Int, column: Int) {
        var items = gameItems
        if selectedItemIndex != nil {
            GameBoardStateHelper.cleanup(in: &items)
        }
        items[row][column].state = .selected
        selectedItemIndex = SudokuGameItem.Index(row: row, column: column)
        updateHilights(in: &items)
        gameItems = items
    }
    
    private func updateHilights(in items: inout [[GameItem]]) {
        GameBoardStateHelper
            .hilightCross(in: &items, selectedItemIndex: selectedItemIndex)
        GameBoardStateHelper
            .hilightBlock(in: &items, selectedItemIndex: selectedItemIndex)
        GameBoardStateHelper
            .hilightSame(in: &items, selectedItemIndex: selectedItemIndex)
    }
    
    private func updateValueForSelectedItem(value: Int?) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        
        var item = gameItems[selectedItemIndex.row][selectedItemIndex.column]
        
        guard value != item.value else { return }
        
        if item.isEditable {
            let previousValue = item.value
            item.value = value
            gameItems[selectedItemIndex.row][selectedItemIndex.column] = item
            gameHistory.append(
                GameHistoryItem(index: item.id, previousValue: previousValue)
            )
            var items = gameItems
            updateHilights(in: &items)
            gameItems = items
            updateFullFilledNumbers()
        }
    }
    
    private func undo(with historyItem: GameHistoryItem) {
        gameItems[historyItem.index.row][historyItem.index.column].value = historyItem.previousValue
        selectedItemAt(row: historyItem.index.row, column: historyItem.index.column)
        updateFullFilledNumbers()
    }
    
    private func eraseSelected() {
        updateValueForSelectedItem(value: nil)
    }
    
    private func updateFullFilledNumbers() {
        var numbersCounts = Array(repeating: 0, count: SudokuConstants.fildSize)
        for row in 0..<gameItems.count {
            for column in 0..<gameItems[row].count {
                if let number = gameItems[row][column].value {
                    numbersCounts[number - 1] += 1
                }
            }
        }
        finishedNumbers = numbersCounts.map { $0 == SudokuConstants.fildSize }
    }
}

// MARK: GameStatsDataProvider
extension GameService: GameStatsDataProvider {
    func maxScore() -> Int {
        return 0
    }
    
    func difficulty() -> String { game.difficulty.name }
    
    func mistakes() -> AnyPublisher<Int, Never> {
        $mistakesCount.eraseToAnyPublisher()
    }
}

// MARK: GameTimeCounter
extension GameService: GameTimeCounter {
    func time() -> AnyPublisher<Int, Never> {
        $inGameTime.eraseToAnyPublisher()
    }
    
    func resumeGame() {
        if !(timer?.isValid ?? false)  {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                self?.inGameTime += 1
            }
            timer?.fire()
        }
    }
    
    func pauseGame() {
        guard timer?.isValid ?? false else { return }
        timer?.invalidate()
        router.showPauseScreen(
            dificulty: game.difficulty.name,
            mistakesCount: mistakesCount,
            time: inGameTime
        )
    }
}

// MARK: NumpadInterectionHandler
extension GameService: NumpadInterectionHandler {
    func numberFinished(_ number: Int) -> AnyPublisher<Bool, Never> {
        $finishedNumbers
            .map { $0[number-1] }
            .eraseToAnyPublisher()
    }
    
    func didTap(number: Int) {
        updateValueForSelectedItem(value: number)
    }
}

// MARK: GameActionsHandler
extension GameService: GameActionsHandler {
    func undo() {
        if (!gameHistory.isEmpty) {
            let lastAction = gameHistory.removeLast()
            undo(with: lastAction)
        }
    }
    
    func erase() {
        eraseSelected()
    }
    
    func hint() {
        
    }
}
