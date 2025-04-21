//
//  GameService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation
import Combine


class GameService: SudokuBoardConentDataSource, SudokuBoardInteractionHandler {
    private let game: SudokuGame
    private var selectedItemIndex: SudokuGameItem.Index?
    private var timer: Timer?
    private var gameHistory: [GameHistoryItem] = []
    @Published private var gameItems: [[GameItem]] = []
    @Published private var mistakesCount: Int = 0
    @Published private var inGameTime: Int = 0
    
    init(game: SudokuGame) {
        self.game = game
        self.gameItems = game.items
            .map { row in row.map { GameItem(sudokuItem: $0)} }
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
        GameBoardStateHelper
            .hilightCross(in: &items, selectedItemIndex: selectedItemIndex)
        GameBoardStateHelper
            .hilightBlock(in: &items, selectedItemIndex: selectedItemIndex)
        GameBoardStateHelper
            .hilightSame(in: &items, selectedItemIndex: selectedItemIndex)
        gameItems = items
    }
    
    private func undo(with historyItem: GameHistoryItem) {
        gameItems[historyItem.gameItem.row][historyItem.gameItem.column].value = historyItem.previousValue
        selectedItemAt(row: historyItem.gameItem.row, column: historyItem.gameItem.column)
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
        timer?.invalidate()
    }
}

// MARK: NumpadInterectionHandler
extension GameService: NumpadInterectionHandler {
    func didTap(number: Int) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        var item = gameItems[selectedItemIndex.row][selectedItemIndex.column]
        if item.isEditable {
            let previousValue = item.value
            item.value = number
            gameItems[selectedItemIndex.row][selectedItemIndex.column] = item
            
            if (item.value != nil && item.value != item.correctValue) {
                mistakesCount += 1
            }
            
            gameHistory.append(
                GameHistoryItem(gameItem: item, previousValue: previousValue)
            )
        }
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
        
    }
    
    func hint() {
        
    }
}
