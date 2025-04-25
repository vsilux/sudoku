//
//  PauseScreen.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import UIKit

protocol PauseScreenNavigationRouter {
    func resumeGame()
}

class PauseViewController: UIViewController {
    @IBOutlet private(set) weak var containerView: UIView!
    @IBOutlet private(set) weak var resumeButton: UIButton!
    @IBOutlet private(set) weak var difficultyLabel: UILabel!
    @IBOutlet private(set) weak var mistakesCountLabel: UILabel!
    @IBOutlet private(set) weak var timeLabel: UILabel!
    @IBOutlet private(set) weak var scoreLabel: UILabel!
    
    var model: PauseScreenModel?
    var router: PauseScreenNavigationRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else { return }
        configure(with: model)
        
    }
    
    private func configure(with model: PauseScreenModel) {
        difficultyLabel.text = model.difficulty
        mistakesCountLabel.text = "\(model.mistakesCount)/3"
        timeLabel.text = Utilities.formatToMinutesAndSeconds(model.time)
        scoreLabel.text = Utilities.formattedScore(model.score)
    }
    
    
    @IBAction private func resumeButtonTapped() {
        model?.resumeAction()
        router?.resumeGame()
    }
}
