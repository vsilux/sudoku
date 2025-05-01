//
//  GameViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 12.04.2025.
//

import UIKit
import Combine

protocol GameScoreProvider {
    func score() -> any Publisher<Int, Never>
}

class GameViewController: UIViewController {
    
    private let gameStatsHeight: CGFloat = 40
    private let numpadHeight: CGFloat = 50
    private let topContentOffset: CGFloat = 30
    private let gameActionsHeight: CGFloat = 60
    private let interContainerOffset: CGFloat = 20
    
    private let gameStatsViewController: UIViewController
    private let boardViewController: UIViewController
    private let boardSizeWidth: CGFloat
    private let gameActionsViewController: UIViewController
    private let numpadViewController: UIViewController
    private let scoreProvider: GameScoreProvider

    private var cancellables: Set<AnyCancellable> = []
    
    init(
        gameStatsViewController: UIViewController,
        boardViewController: UIViewController,
        boardSizeWidth: CGFloat,
        gameActionsViewController: UIViewController,
        numpadViewController: UIViewController,
        scoreProvider: GameScoreProvider
    ) {
        self.gameStatsViewController = gameStatsViewController
        self.boardViewController = boardViewController
        self.boardSizeWidth = boardSizeWidth
        self.gameActionsViewController = gameActionsViewController
        self.numpadViewController = numpadViewController
        self.scoreProvider = scoreProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        embedGameStatsController()
        embedBoardController()
        embedGameActionsController()
        embedNumpadController()
        setupScoreTitle()
    }
    
    private func embedGameStatsController() {
        addChild(gameStatsViewController)
        gameStatsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameStatsViewController.view)
        
        gameStatsViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topContentOffset).isActive = true
        gameStatsViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        gameStatsViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameStatsViewController.view.heightAnchor.constraint(equalToConstant: gameStatsHeight).isActive = true
        
    }
    
    private func embedBoardController() {
        addChild(boardViewController)
        boardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(boardViewController.view)
        
        boardViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boardViewController.view.topAnchor.constraint(equalTo: gameStatsViewController.view.bottomAnchor, constant: interContainerOffset).isActive = true
        boardViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        boardViewController.view.heightAnchor.constraint(equalTo: boardViewController.view.widthAnchor, multiplier: 1.0).isActive = true
        
        boardViewController.didMove(toParent: self)
    }
    
    private func embedGameActionsController() {
        addChild(gameActionsViewController)
        gameActionsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(gameActionsViewController.view)
        
        gameActionsViewController.view.topAnchor.constraint(equalTo: boardViewController.view.bottomAnchor, constant: interContainerOffset).isActive = true
        gameActionsViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameActionsViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        gameActionsViewController.view.heightAnchor.constraint(equalToConstant: gameActionsHeight).isActive = true
    }
    
    private func embedNumpadController() {
        addChild(numpadViewController)
        numpadViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numpadViewController.view)
        
        numpadViewController.view.topAnchor.constraint(equalTo: gameActionsViewController.view.bottomAnchor, constant: interContainerOffset).isActive = true
        numpadViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numpadViewController.view.widthAnchor.constraint(equalToConstant: boardSizeWidth).isActive = true
        numpadViewController.view.heightAnchor.constraint(equalToConstant: numpadHeight).isActive = true
    }
    
    private func setupScoreTitle() {
        scoreProvider.score().sink { [weak self] newScore in
            guard let self = self else { return }
            
            self.title = "\(newScore)"
        }.store(in: &cancellables)
    }

}
