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

    init(boardViewController: UIViewController, boardSizeWidth: CGFloat) {
        self.boardViewController = boardViewController
        self.boardSizeWidth = boardSizeWidth
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        embedBoardController()
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
}
