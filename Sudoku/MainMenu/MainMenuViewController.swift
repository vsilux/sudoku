//
//  MainMenuViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 24.04.2025.
//

import UIKit

protocol MainMenuRouter {
    func showDifficultySelection(difficulties: [SudokuGameModel.Difficulty], completion: @escaping (SudokuGameModel.Difficulty) -> Void)
    func startNewGame(_ difficulty: SudokuGameModel.Difficulty)
    func resum(game: SudokuGameModel)
}

class MainMenuViewController: UIViewController {
    @IBOutlet private(set) var newGameButton: UIButton!
    @IBOutlet private(set) var continueGameButton: UIButton!
    
    var router: MainMenuRouter?
    var repository: GameRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    private func configureContent() {
        do {
            let lastGame = try repository?.fetchLatestGame()
            continueGameButton.isEnabled = lastGame != nil
        } catch {
            continueGameButton.isEnabled = false
        }
    }
    
    @IBAction private func newGameButtonTapped() {
        router?.showDifficultySelection(difficulties: SudokuGameModel.Difficulty.allCases) { [weak self] difficulty in
            self?.router?.startNewGame(difficulty)
        }
    }
    
    @IBAction private func continueGameButtonTapped() {
        do {
            guard let lastGame = try repository?.fetchLatestGame() else { return }
            router?.resum(game: lastGame)
        } catch {
            continueGameButton.isEnabled = false
        }
    }
}
