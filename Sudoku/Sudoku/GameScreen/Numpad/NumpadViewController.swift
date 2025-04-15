//
//  NumpadViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 15.04.2025.
//

import UIKit

protocol NumpadInterectionHandler {
    func didTap(number: Int)
}

class NumpadViewController: UIViewController {
    let totalNumbers: Int = 9
    let buttonSpacing: CGFloat = 10
    let interectionHandler: NumpadInterectionHandler
    private var numpadViews: [UIView] = []
    
    init(interectionHandler: NumpadInterectionHandler) {
        self.interectionHandler = interectionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    func setupContent() {
        for number in 1...totalNumbers {
            let button = UIButton(type: .system, primaryAction: UIAction(handler: {
                [weak self] _ in
                self?.interectionHandler.didTap(number: number)
            }))
            
            button.setTitle("\(number)", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 30)
            view.addSubview(button)
            addConstraints(for: button, previousButton: numpadViews.last)
            numpadViews.append(button)
        }
        numpadViews.last?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func addConstraints(for button: UIButton, previousButton: UIView?) {
        button.translatesAutoresizingMaskIntoConstraints = false
        if let previousButton = previousButton {
            button.leftAnchor.constraint(
                equalTo: previousButton.rightAnchor,
                constant: buttonSpacing
            ).isActive = true
            button.widthAnchor.constraint(equalTo: previousButton.widthAnchor).isActive = true
        } else {
            button.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        }
        
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
