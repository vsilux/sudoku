//
//  GameBoardController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 02.05.2025.
//

import Foundation
import Combine

protocol GameBoardController {
    var selectedItemIndex: GameBoardIndex? { get }
    var gameItemsPublisher: Published<[[GameItem]]>.Publisher { get }
    
    func selectItem(at index: GameBoardIndex)
    
    func valueForItem(at index: GameBoardIndex) -> Int?
    func update(value: Int?, for index: GameBoardIndex) -> Bool
}

class SudokuGameBoardController: GameBoardController, SudokuBoardInteractionHandler, SudokuBoardConentDataSource {
    private let itemRepository: GameItemRepository
    private(set) var selectedItemIndex: GameBoardIndex?
    @Published private var gameItems: [[GameItem]] = []
    var gameItemsPublisher: Published<[[GameItem]]>.Publisher { $gameItems }
    
    init(itemRepository: GameItemRepository, gameItemModels: [[SudokuGameItemModel]]) {
        self.itemRepository = itemRepository
        setupGameItems(gameItemModels)
    }
    
    func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never> {
        $gameItems
            .map { $0[row][column] }
            .eraseToAnyPublisher()
    }
    
    func selectItemAt(row: Int, column: Int) {
        var items = gameItems
        if selectedItemIndex != nil {
            GameBoardStateHelper.cleanup(in: &items)
        }
        items[row][column].state = .selected
        selectedItemIndex = GameBoardIndex(row: row, column: column)
        updateHilights(in: &items)
        gameItems = items
    }
    
    func selectItem(at index: GameBoardIndex) {
        selectItemAt(row: index.row, column: index.column)
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
    
    private func setupGameItems(_ models: [[SudokuGameItemModel]]) {
        self.gameItems = models.map {
            $0.map { itemModel in
                GameItem(model: itemModel)
            }
        }
    }
    
    /// Updates the value of the item at the specified index.
    /// - Returns: `true` if the value was updated, `false` if not.
    func update(value: Int?, for index: GameBoardIndex) -> Bool {
        var item = gameItems[index.row][index.column]
        
        guard value != item.value else { return false}
        
        if item.isEditable {
            item.value = value
            try? itemRepository.updateGameItem(id: item.id, value: value)
            
            var items = gameItems
            items[index.row][index.column] = item
            updateHilights(in: &items)
            gameItems = items
            
            return true
        }
        
        return false
    }
    
    func valueForItem(at index: GameBoardIndex) -> Int? {
        gameItems[index.row][index.column].value
    }
}
