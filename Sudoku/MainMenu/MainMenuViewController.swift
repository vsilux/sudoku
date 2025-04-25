//
//  MainMenuViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 24.04.2025.
//

import UIKit

protocol MainMenuNavigationRouter {
    func startNewGame()
    func continueGame()
}

class MainMenuViewController: UIViewController {
    @IBOutlet private(set) var newGameButton: UIButton!
    @IBOutlet private(set) var continueGameButton: UIButton!
    
    var router: MainMenuNavigationRouter?
    
    @IBAction private func newGameButtonTapped() {
        router?.startNewGame()
    }
    
    @IBAction private func continueGameButtonTapped() {
        router?.continueGame()
    }
}
