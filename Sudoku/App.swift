//
//  App.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import UIKit

enum App {
    // Mark: run initial screen
    static func run(in window: UIWindow, sceneEventStream: SceneEventStream) {
        let router = NavigationRouter()
        let game = SudokuGameGenerator().generateBoard(difficulty: .easy)
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(
            screenWidth: window.bounds.width
        )
        let gameTimeService = GameTimeService(
            sceneEventStream: sceneEventStream
        )
        let gameService = GameService(game: game, timeCounter: gameTimeService)
        
        let gameViewController = GameViewController(
            gameStatsViewController: GameStatsViewController
                .make(with: gameService, router: router),
            boardViewController: SudokuBoardViewController(
                collectionViewLayout: SudokuLayout(sizeProvider: sizeProvider),
                backgroundViewBuilder: SudokuCollectionViewBackgrounViewBuilder(
                    sizeProvider: sizeProvider
                ),
                boardContentDataSource: gameService,
                interactionHandler: gameService
            ),
            boardSizeWidth: sizeProvider.realContentWidth,
            gameActionsViewController: GameActionsViewController
                .make(with: gameService),
            numpadViewController: NumpadViewController(
                interectionHandler: gameService
            )
        )
        
        let navigationViewController = UINavigationController(
            rootViewController: gameViewController
        )
        router.navigationController = navigationViewController
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
