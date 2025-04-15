//
//  SudokuBoardViewControllerTests.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 14.04.2025.
//

import XCTest
@testable import Sudoku

final class SudokuBoardViewControllerTests: XCTestCase {

    func test_NumberOfSections() {
        // Arrange
        let layout = UICollectionViewFlowLayout()
        let mockBackgroundViewBuilder = MockSudokuBackgroundViewBuilder()
        let viewController = SudokuBoardViewController(
            collectionViewLayout: layout,
            backgroundViewBuilder: mockBackgroundViewBuilder,
            boardContentDataSource: MockSudokuBoardContentDataSource()
        )
            
        // Act
        _ = viewController.view // Trigger view loading
        let sections = viewController.numberOfSections(
            in: viewController.collectionView
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
        let layout = UICollectionViewFlowLayout()
        let mockBackgroundViewBuilder = MockSudokuBackgroundViewBuilder()
        let viewController = SudokuBoardViewController(
            collectionViewLayout: layout,
            backgroundViewBuilder: mockBackgroundViewBuilder,
            boardContentDataSource: MockSudokuBoardContentDataSource()
        )
            
        // Act
        _ = viewController.view // Trigger view loading
        let items = viewController.collectionView(
            viewController.collectionView,
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
        let layout = UICollectionViewFlowLayout()
        let mockBackgroundViewBuilder = MockSudokuBackgroundViewBuilder()
        let viewController = SudokuBoardViewController(
            collectionViewLayout: layout,
            backgroundViewBuilder: mockBackgroundViewBuilder,
            boardContentDataSource: MockSudokuBoardContentDataSource()
        )
            
        // Act
        _ = viewController.view // Trigger view loading
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = viewController.collectionView(
            viewController.collectionView,
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
    
    // MARK: - Mock Classes
    
    class MockSudokuBackgroundViewBuilder: SudokuBakgroundViewBuilder {
        func build() -> UIView {
            return UIView()
        }
    }
    
    class MockSudokuBoardContentDataSource: SudokuBoardConentDataSource {
        func itemFor(row: Int, column: Int) -> SudokuBoardItem {
            return MockSudokuBoardItem(
                row: row,
                column: column,
                isEditable: true,
                value: nil,
                isCorrect: false
            )
        }
    }
    
    struct MockSudokuBoardItem: SudokuBoardItem {
        var row: Int
        var column: Int
        var isEditable: Bool
        var value: Int?
        var isCorrect: Bool
    }

}
