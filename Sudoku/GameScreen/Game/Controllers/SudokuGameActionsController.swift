//
//  BoardInteractionController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 02.05.2025.
//

import Foundation
import Combine

class SudokuGameActionsController: NumpadInterectionHandler, GameActionsHandler {
    private let scoreController: GameScoreController
    private let boardController: GameBoardController
    private(set) var history: [GameHistoryItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var finishedNumbers = Array(
        repeating: false,
        count: SudokuConstants.fildSize
    )
    
    init(
        scoreController: GameScoreController,
        boardController: GameBoardController,
    ) {
        self.scoreController = scoreController
        self.boardController = boardController
        subscribeToItemsUpdate()
    }
    
    func numberFinished(_ number: Int) -> AnyPublisher<Bool, Never> {
        $finishedNumbers
            .map { $0[number-1] }
            .eraseToAnyPublisher()
    }
    
    func didTap(number: Int) {
        updateValueForSelectedItem(value: number)
    }
    
    func undo(with historyItem: GameHistoryItem) {
        _ = boardController.update(value: historyItem.previousValue, for: historyItem.index)
        boardController.selectItem(at: historyItem.index)
    }
    
    func undo() {
        if (!history.isEmpty) {
            let lastAction = history.removeLast()
            undo(with: lastAction)
        }
    }
    
    func erase() {
        updateValueForSelectedItem(value: nil)
    }
    
    func hint() {
        
    }
    
    func subscribeToItemsUpdate() {
        boardController.gameItemsPublisher.sink { [weak self] gameItems in
            guard let self = self else { return }
            
            var numbersCounts = Array(repeating: 0, count: SudokuConstants.fildSize)
            for row in 0..<gameItems.count {
                for column in 0..<gameItems[row].count {
                    if let number = gameItems[row][column].value {
                        numbersCounts[number - 1] += 1
                    }
                }
            }
            self.finishedNumbers = numbersCounts.map { $0 == SudokuConstants.fildSize }
        }.store(in: &cancellables)
    }
    
    private func updateValueForSelectedItem(value: Int?) {
        guard let selectedItemIndex = boardController.selectedItemIndex else {
            return
        }
        
        let previousValue = boardController.valueForItem(at: selectedItemIndex)
        
        guard boardController
            .update(value: value, for: selectedItemIndex) else { return }
        
        scoreController.updateScore(for: selectedItemIndex)
        history.append(
            GameHistoryItem(
                index: GameBoardIndex(
                    row: selectedItemIndex.row,
                    column: selectedItemIndex.column
                ),
                previousValue: previousValue
            )
        )
    }
}
