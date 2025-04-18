//
//  SudokuBoardViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 13.04.2025.
//

import UIKit
import Combine

protocol SudokuBoardConentDataSource {
    func itemPublisherFor(row: Int, column: Int) -> AnyPublisher<any SudokuBoardItem, Never>
}

protocol SudokuBoardInteractionHandler {
    func selectedItemAt(row: Int, column: Int)
}

class SudokuBoardViewController: UICollectionViewController {
    private let backgroundViewBuilder: SudokuBakgroundViewBuilder
    private let boardContentDataSource: SudokuBoardConentDataSource
    private let interactionHandler: SudokuBoardInteractionHandler
    
    init(
        collectionViewLayout layout: UICollectionViewLayout,
        backgroundViewBuilder: SudokuBakgroundViewBuilder,
        boardContentDataSource: SudokuBoardConentDataSource,
        interactionHandler: SudokuBoardInteractionHandler
    ) {
        self.backgroundViewBuilder = backgroundViewBuilder
        self.boardContentDataSource = boardContentDataSource
        self.interactionHandler = interactionHandler
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
        
        cell.bind(to: boardContentDataSource.itemPublisherFor(row: indexPath.section, column: indexPath.item))
        
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactionHandler.selectedItemAt(row: indexPath.section, column: indexPath.item)
    }
}
