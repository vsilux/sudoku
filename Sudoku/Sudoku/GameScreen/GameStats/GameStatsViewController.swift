//
//  GameStatsViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 17.04.2025.
//

import UIKit
import Combine

protocol GameStatsDataProvider {
    func maxScore() -> Int
    func difficulty() -> String
    func mistakes() -> AnyPublisher<Int, Never>
}

protocol GameTimeCounter {
    func resumeGame()
    func pauseGame()
    func time() -> AnyPublisher<Int, Never>
}

class GameStatsViewController: UIViewController {
    @IBOutlet private(set) weak var maxScoreLabel: UILabel!
    @IBOutlet private(set) weak var difficultyLabel: UILabel!
    @IBOutlet private(set) weak var mistakesLabel: UILabel!
    @IBOutlet private(set) weak var timeLabel: UILabel!
    @IBOutlet private(set) weak var pouseButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    var dataProvider: GameStatsDataProvider?
    var timeCounter: GameTimeCounter?
    
    static func make(with dataProvider: GameStatsDataProvider, timeCounter: GameTimeCounter) -> GameStatsViewController {
        let storyboard = UIStoryboard(name: "GameStats", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! GameStatsViewController
        viewController.dataProvider = dataProvider
        viewController.timeCounter = timeCounter
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timeCounter?.resumeGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timeCounter?.pauseGame()
    }
    
    private func configureContent() {
        guard let dataProvider = dataProvider else { return }
        self.maxScoreLabel.text = formattedScore(dataProvider.maxScore())
        self.difficultyLabel.text = dataProvider.difficulty()
        
        dataProvider.mistakes().sink { [weak self] numberOfMistakes in
            self?.mistakesLabel.text = "\(numberOfMistakes)/\(SudokuConstants.maxMistakes)"
        }.store(in: &cancellables)
        
        guard let timeCounter = timeCounter else { return }
        
        timeCounter.time().sink { [weak self] time in
            self?.timeLabel.text = self?.formatToMinutesAndSeconds(time)
        }.store(in: &cancellables)
    }

    private func formattedScore(_ score: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        return formatter.string(for: score) ?? "\(score)"
    }
    
    private func formatToMinutesAndSeconds(_ timeInterval: Int) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction private func onPouseButtonTap(_ sender: UIButton) {
        
    }
}
