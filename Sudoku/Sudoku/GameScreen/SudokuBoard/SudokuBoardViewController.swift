//
//  SudokuBoardViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 13.04.2025.
//

import UIKit

protocol SudokuBoardItem {
    var row: Int { get }
    var column: Int { get }
    var isEditable: Bool { get }
    var value: Int? { get }
    var isCorrect: Bool { get }
}


protocol SudokuBoardConentDataSource {
    func itemFor(row: Int, column: Int) -> SudokuBoardItem
}

class SudokuBoardViewController: UICollectionViewController {
    
    private let backgroundViewBuilder: SudokuBakgroundViewBuilder
    private let boardContentDataSource: SudokuBoardConentDataSource
    
    init(collectionViewLayout layout: UICollectionViewLayout, backgroundViewBuilder: SudokuBakgroundViewBuilder, boardContentDataSource: SudokuBoardConentDataSource) {
        self.backgroundViewBuilder = backgroundViewBuilder
        self.boardContentDataSource = boardContentDataSource
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SudokuBoardItemCell.self, forCellWithReuseIdentifier: SudokuBoardItemCell.identifier)
        collectionView.backgroundView = backgroundViewBuilder.build()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SudokuConstants.fildSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SudokuConstants.fildSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SudokuBoardItemCell.identifier, for: indexPath) as? SudokuBoardItemCell
            else { preconditionFailure("Failed to load collection view cell") }
        
        cell.configureCell(
            with: boardContentDataSource.itemFor(
                row: indexPath.section,
                column: indexPath.item
            )
        )
        
        cell.contentView.backgroundColor = .white
        return cell
    }
}
