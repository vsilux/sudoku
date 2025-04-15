//
//  GameViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit

class GameViewController: UIViewController {
    
    private let boardViewController: UIViewController
    private let boardSizeWidth: CGFloat
    private let numpadViewController: UIViewController

    init(
        boardViewController: UIViewController,
        boardSizeWidth: CGFloat,
        numpadViewController: UIViewController
    ) {
        self.boardViewController = boardViewController
        self.boardSizeWidth = boardSizeWidth
        self.numpadViewController = numpadViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        embedBoardController()
        embedNumpadController()
    }
    
    private func embedBoardController() {
        addChild(boardViewController)
        boardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(boardViewController.view)
        
        boardViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boardViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        boardViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        boardViewController.view.heightAnchor.constraint(equalTo: boardViewController.view.widthAnchor, multiplier: 1.0).isActive = true
        
        boardViewController.didMove(toParent: self)
    }
    
    private func embedNumpadController() {
        addChild(numpadViewController)
        numpadViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numpadViewController.view)
        
        numpadViewController.view.topAnchor.constraint(equalTo: boardViewController.view.bottomAnchor, constant: 20).isActive = true
        numpadViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numpadViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        numpadViewController.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
