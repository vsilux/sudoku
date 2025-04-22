//
//  GameStatsViewController.swift
//  Sudoku
//
//  Created by Illia Suvorov on 17.04.2025.
//

import UIKit
import Combine

protocol GameTimeCounter {
    func startGame()
    func stopGame()
    func time() -> AnyPublisher<Int, Never>
    func currentTime() -> Int
}

protocol GameStatsDataProvider {
    var timeCounter: GameTimeCounter { get }
    func mistakes() -> AnyPublisher<Int, Never>
    func gameStats() -> GameStats
}

protocol GameStatsNavigationRouter {
    func showPauseScreen(
        gameStats: GameStats,
        resumeAction: @escaping () -> Void
    )
}

class GameStatsViewController: UIViewController {
    @IBOutlet private(set) weak var maxScoreLabel: UILabel!
    @IBOutlet private(set) weak var difficultyLabel: UILabel!
    @IBOutlet private(set) weak var mistakesLabel: UILabel!
    @IBOutlet private(set) weak var timeLabel: UILabel!
    @IBOutlet private(set) weak var pouseButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    var dataProvider: GameStatsDataProvider?
    var router: GameStatsNavigationRouter?
    
    static func make(with dataProvider: GameStatsDataProvider, router: GameStatsNavigationRouter) -> GameStatsViewController {
        let storyboard = UIStoryboard(name: "GameStats", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! GameStatsViewController
        viewController.dataProvider = dataProvider
        viewController.router = router
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataProvider?.timeCounter.startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataProvider?.timeCounter.stopGame()
    }
    
    private func configureContent() {
        guard let dataProvider = dataProvider else { return }
        let gameStats = dataProvider.gameStats()
        self.maxScoreLabel.text = Utilities.formattedScore(gameStats.maxScore)
        self.difficultyLabel.text = gameStats.difficulty
        
        dataProvider.mistakes().sink { [weak self] numberOfMistakes in
            self?.mistakesLabel.text = "\(numberOfMistakes)/\(SudokuConstants.maxMistakes)"
        }.store(in: &cancellables)
        
        dataProvider.timeCounter.time().sink { [weak self] time in
            self?.timeLabel.text = Utilities.formatToMinutesAndSeconds(time)
        }.store(in: &cancellables)
    }
    
    @IBAction private func onPouseButtonTapped(_ sender: UIButton) {
        guard let dataProvider = dataProvider else { return }
        dataProvider.timeCounter.stopGame()
        router?
            .showPauseScreen(gameStats: dataProvider.gameStats()) { [weak self] in
                self?.dataProvider?.timeCounter.startGame()
            }
    }
}
