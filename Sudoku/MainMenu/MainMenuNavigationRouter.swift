//
//  MainMenuNavigationRouter.swift
//  Sudoku
//
//  Created by Illia Suvorov on 27.04.2025.
//

import UIKit

protocol WindowBoundsProvider {
    var bounds: CGRect { get }
}

class MainMenuNavigationRouter: MainMenuRouter {
    private let selectDifficultyTitle = "Select Difficulty"
    
    private let repositoryProvider: RepositoryProvider
    private let scenEventStream: SceneEventStream
    private let gameGenerator: GameGenerator
    private let windowBoundsProvider: WindowBoundsProvider
    weak var navigationController: UINavigationController?
    
    init(
        repositoryProvider: RepositoryProvider,
        scenEventStream: SceneEventStream,
        gameGenerator: GameGenerator,
        windowBoundsProvider: WindowBoundsProvider
    ) {
        self.repositoryProvider = repositoryProvider
        self.scenEventStream = scenEventStream
        self.gameGenerator = gameGenerator
        self.windowBoundsProvider = windowBoundsProvider
    }
    
    func startNewGame(_ difficulty: SudokuGameModel.Difficulty) {
        if let (game, gameItems) = try? gameGenerator.generateGame(difficulty: difficulty) {
            start(game: game, gameItems: gameItems)
        }
    }
    
    func resum(game: SudokuGameModel) {
        if let items = try? repositoryProvider.gameItemRepository().items(for: game) {
            start(game: game, gameItems: items)
        }
    }
    
    private func start(game: SudokuGameModel, gameItems: [[SudokuGameItemModel]]) {
        let gameInteractor = SudokuGameInteractor(game: game, repository: repositoryProvider.gameRepository())
        let gameScoreController = SudokuGameScoreController(gameInteractor: gameInteractor, gameItemModels: gameItems)
        let boardController = SudokuGameBoardController(itemRepository: repositoryProvider.gameItemRepository(), gameItemModels: gameItems)
        let timeCounter = GameTimeController(gameInteractor: gameInteractor, sceneEventStream: scenEventStream)
        let actionsController = SudokuGameActionsController(
            scoreController: gameScoreController,
            boardController: boardController
        )
        let statsController = SudokuGameStatsDataProvider(gameInteractor: gameInteractor, timeCounter: timeCounter)
        
        let router = GameNavigationRouter()
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(
            screenWidth: windowBoundsProvider.bounds.width
        )
        
        let gameViewController = GameViewController(
            gameStatsViewController: GameStatsViewController
                .make(with: statsController, router: router),
            boardViewController: SudokuBoardViewController(
                collectionViewLayout: SudokuLayout(sizeProvider: sizeProvider),
                backgroundViewBuilder: SudokuCollectionViewBackgrounViewBuilder(
                    sizeProvider: sizeProvider
                ),
                boardContentDataSource: boardController,
                interactionHandler: boardController
            ),
            boardSizeWidth: sizeProvider.realContentWidth,
            gameActionsViewController: GameActionsViewController
                .make(with: actionsController),
            numpadViewController: NumpadViewController(
                interectionHandler: actionsController
            ),
            scoreProvider: gameScoreController
        )
        
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    func showDifficultySelection(difficulties: [SudokuGameModel.Difficulty], completion: @escaping (SudokuGameModel.Difficulty) -> Void) {
        let alertController = UIAlertController(title: selectDifficultyTitle, message: nil, preferredStyle: .actionSheet)
        for difficulty in difficulties {
            alertController.addAction(UIAlertAction(title: difficulty.name, style: .default) { _ in
                completion(difficulty)
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        navigationController?.present(alertController, animated: true)
    }
}
