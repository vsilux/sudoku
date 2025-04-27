//
//  SudokuGameController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 27.04.2025.
//

import Foundation
import Combine

class SudokuGameController {
    typealias Index = (row: Int, column: Int)
    private var selectedItemIndex: Index?
    private var gameHistory: [GameHistoryItem] = []
    private let gameRepository: GameRepository
    private let gameItemRepository: GameItemRepository
    let timeCounter: GameTimeCounter
    
    @Published private var game: SudokuGameModel
    @Published private var finishedNumbers = Array(
        repeating: false,
        count: SudokuConstants.fildSize
    )
    @Published private var gameItems: [[GameItem]] = []
    
    init(
        gameRepository: GameRepository,
        gameItemRepository: GameItemRepository,
        timeCounter: GameTimeCounter,
        game: SudokuGameModel,
        gameItemModels: [[SudokuGameItemModel]]
    ) {
        self.gameRepository = gameRepository
        self.gameItemRepository = gameItemRepository
        self.timeCounter = timeCounter
        self.game = game
        setupGameItems(gameItemModels)
    }
    
    private func setupGameItems(_ models: [[SudokuGameItemModel]]) {
        self.gameItems = models.map {
            $0.map { itemModel in
                GameItem(model: itemModel)
            }
        }
    }
    
    private func updateHilights(in items: inout [[GameItem]]) {
        GameBoardStateHelper.hilightCross(
            in: &items,
            selectedItemIndex: selectedItemIndex
        )
        GameBoardStateHelper.hilightBlock(
            in: &items,
            selectedItemIndex: selectedItemIndex
        )
        GameBoardStateHelper.hilightSame(
            in: &items,
            selectedItemIndex: selectedItemIndex
        )
    }
    
    private func updateValueForSelectedItem(value: Int?) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        
        var item = gameItems[selectedItemIndex.row][selectedItemIndex.column]
        
        guard value != item.value else { return }
        
        if item.isEditable {
            let previousValue = item.value
            item.value = value
            try? gameItemRepository.updateGameItem(id: item.id, value: value)
            gameItems[selectedItemIndex.row][selectedItemIndex.column] = item
            gameHistory.append(
                GameHistoryItem(
                    id: item.id,
                    row: item.row,
                    column: item.column,
                    previousValue: previousValue
                )
            )
            var items = gameItems
            updateHilights(in: &items)
            gameItems = items
            updateFullFilledNumbers()
        }
    }
    
    private func undo(with historyItem: GameHistoryItem) {
        gameItems[historyItem.row][historyItem.column].value = historyItem.previousValue
        try? gameItemRepository.updateGameItem(id: historyItem.id, value: historyItem.previousValue)
        selectItemAt(row: historyItem.row, column: historyItem.column)
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

// MARK: SudokuBoardInteractionHandler
extension SudokuGameController: SudokuBoardInteractionHandler {
    func selectItemAt(row: Int, column: Int) {
        var items = gameItems
        if selectedItemIndex != nil {
            GameBoardStateHelper.cleanup(in: &items)
        }
        items[row][column].state = .selected
        selectedItemIndex = (row: row, column: column)
        updateHilights(in: &items)
        gameItems = items
    }
}

// MARK: SudokuBoardConentDataSource
extension SudokuGameController: SudokuBoardConentDataSource {
    func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never> {
        $gameItems
            .map { $0[row][column] }
            .eraseToAnyPublisher()
    }
}

// MARK: GameStatsDataProvider
extension SudokuGameController: GameStatsDataProvider {
    func gameStats() -> any GameStats {
        return GameStatsModel(
            difficulty: game.difficulty.name,
            mistakesCount: game.mistakesCount,
            time: timeCounter.currentTime(),
            score: game.score,
            maxScore: 0
        )
    }
    
    func mistakes() -> AnyPublisher<Int, Never> {
        $game.map { $0.mistakesCount }
            .eraseToAnyPublisher()
    }
}

// MARK: NumpadInterectionHandler
extension SudokuGameController: NumpadInterectionHandler {
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
extension SudokuGameController: GameActionsHandler {
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

