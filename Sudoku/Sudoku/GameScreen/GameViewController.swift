//
//  GameViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private(set) var collectionView: UICollectionView!
    @IBOutlet private(set) var boardWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(screenWidth: UIScreen.main.bounds.width)
        boardWidthConstraint.constant = sizeProvider.realContentWidth
        collectionView.collectionViewLayout = SudokuLayout(sizeProvider: sizeProvider)
        collectionView.backgroundView = collectionViewBackgroundView(for: sizeProvider)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SudokuConstants.fildSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SudokuConstants.fildSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SudokuCell.identifier, for: indexPath) as? SudokuCell
            else { preconditionFailure("Failed to load collection view cell") }
        
        cell.setNumber(indexPath.item)
        cell.contentView.backgroundColor = .white
        return cell
    }
    
    private func collectionViewBackgroundView(for sizeProvider: SudokuBoardSizeProvider) -> UIView {
        let backgrounView = UIView()
        backgrounView.backgroundColor = .black
        let lightBoxSize = sizeProvider.cellSize * Double(SudokuConstants.fildBlocSize) + sizeProvider.smallOffset * 2
        for row in 0..<SudokuConstants.fildBlocSize {
            for column in 0..<SudokuConstants.fildBlocSize {
                let lightBox = UIView()
                lightBox.backgroundColor = .lightGray
                lightBox.frame = CGRect(
                    x: sizeProvider.largeOffset + (lightBoxSize + sizeProvider.largeOffset) * Double(column),
                    y: sizeProvider.largeOffset + (lightBoxSize + sizeProvider.largeOffset) * Double(row),
                    width: lightBoxSize,
                    height: lightBoxSize
                )
                backgrounView.addSubview(lightBox)
            }
        }
        
        return backgrounView
    }
}
