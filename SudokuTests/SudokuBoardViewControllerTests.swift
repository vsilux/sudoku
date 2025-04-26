//
//  SudokuBoardViewControllerTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 14.04.2025.
//

import XCTest
import Combine
@testable import Sudoku

final class SudokuBoardViewControllerTests: XCTestCase {

    func test_NumberOfSections() {
        // Arrange
        let sut = makeSUT()
            
        // Act
        _ = sut.view // Trigger view loading
        let sections = sut.numberOfSections(
            in: sut.collectionView
        )
            
        // Assert
        XCTAssertEqual(
            sections,
            SudokuConstants.fildSize,
            "The number of sections should match the Sudoku field size."
        )
    }
        
    func test_NumberOfItemsInSection() {
        // Arrange
        let sut = makeSUT()
            
        // Act
        _ = sut.view // Trigger view loading
        let items = sut.collectionView(
            sut.collectionView,
            numberOfItemsInSection: 0
        )
            
        // Assert
        XCTAssertEqual(
            items,
            SudokuConstants.fildSize,
            "The number of items in a section should match the Sudoku field size."
        )
    }
        
    func test_CellForItemAt() {
        // Arrange
        let sut = makeSUT()
            
        // Act
        _ = sut.view // Trigger view loading
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = sut.collectionView(
            sut.collectionView,
            cellForItemAt: indexPath
        ) as? SudokuBoardItemCell
            
        // Assert
        XCTAssertNotNil(cell, "The cell should not be nil.")
        XCTAssertEqual(
            cell?.contentView.backgroundColor,
            .white,
            "The cell's background color should be white."
        )
    }
    
    // MARK: - Helpers
    
    func makeSUT() -> SudokuBoardViewController {
        let layout = UICollectionViewFlowLayout()
        let mockBackgroundViewBuilder = MockSudokuBackgroundViewBuilder()
        let mockInteractionHandler = MockSudokuBoardInteractionHandler()
        let viewController = SudokuBoardViewController(
            collectionViewLayout: layout,
            backgroundViewBuilder: mockBackgroundViewBuilder,
            boardContentDataSource: MockSudokuBoardContentDataSource(),
            interactionHandler: mockInteractionHandler
        )
        
        return viewController
    }
    
    // MARK: - Mock Classes
    
    class MockSudokuBackgroundViewBuilder: SudokuBakgroundViewBuilder {
        func build() -> UIView {
            return UIView()
        }
    }
    
    class MockSudokuBoardContentDataSource: SudokuBoardConentDataSource {
        func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never> {
            return Just(MockSudokuBoardItem(
                state: .normal,
                row: row,
                column: column,
                isEditable: true,
                value: nil,
                isCorrect: false
            )).eraseToAnyPublisher()
        }
    }
    
    struct MockSudokuBoardItem: SudokuBoardItem {
        var state: Sudoku.SudokuItemState
        var row: Int
        var column: Int
        var isEditable: Bool
        var value: Int?
        var isCorrect: Bool
    }
    
    class MockSudokuBoardInteractionHandler: SudokuBoardInteractionHandler {
        var selectedItemIndex: [GameService.Index] = []
        func selectedItemAt(row: Int, column: Int) {
            selectedItemIndex.append(GameService.Index(row: row, column: column))
        }
    }

}
