//
//  SudokuCell.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit

class SudokuBoardItemCell: UICollectionViewCell {
    
    private let fontSize = 30.0
    
    static let identifier = String(describing: SudokuBoardItemCell.self)
    
    private let numberLable: UILabel = UILabel()
    private var item: SudokuBoardItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContent() {
        numberLable.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        numberLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(numberLable)
        numberLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func configureCell(with item: SudokuBoardItem) {
        setNumber(item.value ?? 0)
    }
    
    private func setNumber(_ number: Int) {
        if number != 0 {
            numberLable.text = "\(number)"
        } else {
            numberLable.text = ""
        }
    }

}
