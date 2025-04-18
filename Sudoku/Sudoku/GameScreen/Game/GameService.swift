//
//  GameService.swift
//  Sudoku
//
//  Created by Illia Suvorov on 16.04.2025.
//

import Foundation
import Combine


class GameService: SudokuBoardConentDataSource, NumpadInterectionHandler, SudokuBoardInteractionHandler, GameStatsDataProvider {
    private let game: SudokuGame
    private var selectedItemIndex: SudokuGameItem.Index?
    private var timer: Timer?
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
    
    func didTap(number: Int) {
        guard let selectedItemIndex = selectedItemIndex else { return }
        
        if gameItems[selectedItemIndex.row][selectedItemIndex.column].isEditable {
            gameItems[selectedItemIndex.row][selectedItemIndex.column].value = number
        }
    }
    
    func maxScore() -> Int {
        return 0
    }
    
    func difficulty() -> String { game.difficulty.name }
    
    func mistakes() -> AnyPublisher<Int, Never> {
        $mistakesCount.eraseToAnyPublisher()
    }
    
    func time() -> AnyPublisher<Int, Never> {
        $inGameTime.eraseToAnyPublisher()
    }
}
