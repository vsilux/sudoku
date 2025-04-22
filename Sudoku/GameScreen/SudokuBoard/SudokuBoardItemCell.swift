//
//  SudokuCell.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit
import Combine

enum SudokuItemState {
    case normal
    case selected
    case subtleHighlight
    case highlight
}

protocol SudokuBoardItem: Equatable {
    var row: Int { get }
    var column: Int { get }
    var isEditable: Bool { get }
    var value: Int? { get }
    var isCorrect: Bool { get }
    var state: SudokuItemState { get }
}

class SudokuBoardItemCell: UICollectionViewCell {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fontSize = 30.0
    
    static let identifier = String(describing: SudokuBoardItemCell.self)
    
    private let numberLable: UILabel = UILabel()
    private var item: (any SudokuBoardItem)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    private func configureContent() {
        backgroundColor = .white
        numberLable.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        numberLable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(numberLable)
        numberLable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        numberLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func bind(to publisher: AnyPublisher<any SudokuBoardItem, Never>) {
            publisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] item in
                    self?.configureCell(with: item)
                }
                .store(in: &cancellables)
        }
    
    private func configureCell(with item: any SudokuBoardItem) {
        configureWith(number: item.value ?? 0)
        configureFor(state: item.state)
        update(isCorrect: item.isCorrect)
    }
    
    private func configureWith(number: Int) {
        if number != 0 {
            numberLable.text = "\(number)"
        } else {
            numberLable.text = ""
        }
    }
    
    private func configureFor(state: SudokuItemState) {
        switch state {
        case .normal:
            contentView.backgroundColor = .white
        case .selected:
            contentView.backgroundColor = .blue.withAlphaComponent(0.15)
        case .subtleHighlight:
            contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        case .highlight:
            contentView.backgroundColor = .lightGray.withAlphaComponent(0.6)
        }
    }
    
    private func update(isCorrect: Bool) {
        numberLable.textColor = isCorrect ? .black : .red
    }

}
