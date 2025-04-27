////
////  GameService.swift
////  Sudoku
////
////  Created by Illia Suvorov on 16.04.2025.
////
//
//import Foundation
//import Combine
//
//class GameService: SudokuBoardConentDataSource, SudokuBoardInteractionHandler {
//    typealias Index = (row: Int, column: Int)
//    private let game: SudokuGame
//    private var selectedItemIndex: Index?
//    private var gameHistory: [GameHistoryItem] = []
//    @Published private var finishedNumbers = Array(
//        repeating: false,
//        count: SudokuConstants.fildSize
//    )
//    @Published private var gameItems: [[GameItem]] = []
//    @Published private var mistakesCount = 0
//    @Published private var score = 0
//    
//    let timeCounter: GameTimeCounter
//    
//    init(game: SudokuGame, timeCounter: GameTimeCounter) {
//        self.game = game
//        self.timeCounter = timeCounter
//        self.gameItems = game.items
//            .map { row in row.map { GameItem(sudokuItem: $0) } }
//    }
//    
//    func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never> {
//        $gameItems
//            .map { $0[row][column] }
//            .eraseToAnyPublisher()
//    }
//    
//    func selectedItemAt(row: Int, column: Int) {
//        var items = gameItems
//        if selectedItemIndex != nil {
//            GameBoardStateHelper.cleanup(in: &items)
//        }
//        items[row][column].state = .selected
//        selectedItemIndex = (row: row, column: column)
//        updateHilights(in: &items)
//        gameItems = items
//    }
//    
//    private func updateHilights(in items: inout [[GameItem]]) {
//        GameBoardStateHelper
//            .hilightCross(in: &items, selectedItemIndex: selectedItemIndex)
//        GameBoardStateHelper
//            .hilightBlock(in: &items, selectedItemIndex: selectedItemIndex)
//        GameBoardStateHelper
//            .hilightSame(in: &items, selectedItemIndex: selectedItemIndex)
//    }
//    
//    private func updateValueForSelectedItem(value: Int?) {
//        guard let selectedItemIndex = selectedItemIndex else { return }
//        
//        var item = gameItems[selectedItemIndex.row][selectedItemIndex.column]
//        
//        guard value != item.value else { return }
//        
//        if item.isEditable {
//            let previousValue = item.value
//            item.value = value
//            gameItems[selectedItemIndex.row][selectedItemIndex.column] = item
//            gameHistory.append(
//                GameHistoryItem(
//                    row: item.row,
//                    column: item.column,
//                    previousValue: previousValue
//                )
//            )
//            var items = gameItems
//            updateHilights(in: &items)
//            gameItems = items
//            updateFullFilledNumbers()
//        }
//    }
//    
//    private func undo(with historyItem: GameHistoryItem) {
//        gameItems[historyItem.row][historyItem.column].value = historyItem.previousValue
//        selectedItemAt(row: historyItem.row, column: historyItem.column)
//        updateFullFilledNumbers()
//    }
//    
//    private func eraseSelected() {
//        updateValueForSelectedItem(value: nil)
//    }
//    
//    private func updateFullFilledNumbers() {
//        var numbersCounts = Array(repeating: 0, count: SudokuConstants.fildSize)
//        for row in 0..<gameItems.count {
//            for column in 0..<gameItems[row].count {
//                if let number = gameItems[row][column].value {
//                    numbersCounts[number - 1] += 1
//                }
//            }
//        }
//        finishedNumbers = numbersCounts.map { $0 == SudokuConstants.fildSize }
//    }
//}
//
//// MARK: GameStatsDataProvider
//extension GameService: GameStatsDataProvider {
//    func gameStats() -> any GameStats {
//        return GameStatsModel(
//            difficulty: game.difficulty.name,
//            mistakesCount: mistakesCount,
//            time: timeCounter.currentTime(),
//            score: score,
//            maxScore: 0
//        )
//    }
//    
//    func mistakes() -> AnyPublisher<Int, Never> {
//        $mistakesCount.eraseToAnyPublisher()
//    }
//}
//
//// MARK: NumpadInterectionHandler
//extension GameService: NumpadInterectionHandler {
//    func numberFinished(_ number: Int) -> AnyPublisher<Bool, Never> {
//        $finishedNumbers
//            .map { $0[number-1] }
//            .eraseToAnyPublisher()
//    }
//    
//    func didTap(number: Int) {
//        updateValueForSelectedItem(value: number)
//    }
//}
//
//// MARK: GameActionsHandler
//extension GameService: GameActionsHandler {
//    func undo() {
//        if (!gameHistory.isEmpty) {
//            let lastAction = gameHistory.removeLast()
//            undo(with: lastAction)
//        }
//    }
//    
//    func erase() {
//        eraseSelected()
//    }
//    
//    func hint() {
//        
//    }
//}
