//
//  GameActionsViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 18.04.2025.
//

import UIKit

protocol GameActionsHandler {
    func undo()
    func erase()
    func hint()
}

class GameActionsViewController: UIViewController {
    @IBOutlet private(set) weak var undoButton: UIButton!
    @IBOutlet private(set) weak var eraseButton: UIButton!
    @IBOutlet private(set) weak var hintButton: UIButton!
    
    var gameActionsHandler: GameActionsHandler?
    
    static func make(with gameActionsHandler: GameActionsHandler) -> GameActionsViewController {
        let storyboard = UIStoryboard(name: "GameActions", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! GameActionsViewController
        viewController.gameActionsHandler = gameActionsHandler
        return viewController
    }
    
    @IBAction private func undoButtonTapped(_ sender: UIButton) {
        gameActionsHandler?.undo()
    }
    
    @IBAction private func eraseButtonTapped(_ sender: UIButton) {
        gameActionsHandler?.erase()
    }
    
    @IBAction private func hintButtonTapped(_ sender: UIButton) {
        gameActionsHandler?.hint()
    }
}
