//
//  SudokuCell.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit

class SudokuCell: UICollectionViewCell {
    static let identifier = "SudokuCell"
    
    @IBOutlet private(set) var numberLable: UILabel!
    
    func setNumber(_ number: Int) {
        numberLable.text = "\(number)"
    }
}
