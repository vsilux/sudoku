//
//  NavigationRouter.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import UIKit

class GameNavigationRouter: GameStatsNavigationRouter {
    weak var navigationController: UINavigationController?
    
    func showPauseScreen(
        gameStats: GameStats,
        resumeAction: @escaping () -> Void
    ) {
        guard let pauseScreenViewController = UIStoryboard(name: "PauseScreen", bundle: nil).instantiateInitialViewController() as? PauseViewController else {
            return
        }
       
        let pauseScreenModel = PauseScreenModel(
            difficulty: gameStats.difficulty,
            mistakesCount: gameStats.mistakesCount,
            time: gameStats.time,
            score: gameStats.score,
            resumeAction: resumeAction
        )
            
        pauseScreenViewController.model = pauseScreenModel
        pauseScreenViewController.router = self
        pauseScreenViewController.modalPresentationStyle = .overCurrentContext
        pauseScreenViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(pauseScreenViewController, animated: true)
    }
}

extension GameNavigationRouter: PauseScreenNavigationRouter {
    func resumeGame() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
