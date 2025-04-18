//
//  SudokuBackgrounViewBuilder.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import UIKit

protocol SudokuBakgroundViewBuilder {
    func build() -> UIView
}

struct SudokuCollectionViewBackgrounViewBuilder: SudokuBakgroundViewBuilder {
    let sizeProvider: SudokuBoardSizeProvider
    
    init(sizeProvider: SudokuBoardSizeProvider) {
        self.sizeProvider = sizeProvider
    }
    
    func build() -> UIView {
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
