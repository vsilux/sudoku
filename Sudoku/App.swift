//
//  App.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import UIKit

enum App {
    private static func makeBoardViewController(
        _ sizeProvider: SudokuBoardSizeProvider,
        boardContentDataSource: SudokuBoardConentDataSource,
        interactionHandler: any SudokuBoardInteractionHandler
    ) -> UIViewController {
        return SudokuBoardViewController(
            collectionViewLayout: SudokuLayout(sizeProvider: sizeProvider),
            backgroundViewBuilder: SudokuCollectionViewBackgrounViewBuilder(sizeProvider: sizeProvider),
            boardContentDataSource: boardContentDataSource,
            interactionHandler: interactionHandler
        )
    }
    
    private static func makeNumpadViewController(_ interectionHandler: NumpadInterectionHandler) -> UIViewController {
        return NumpadViewController(interectionHandler: interectionHandler)
    }
    
    private static func makeGameStatsViewController(_ dataProvider: GameStatsDataProvider, timeCounter: GameTimeCounter) -> UIViewController {
        return GameStatsViewController.make(with: dataProvider, timeCounter: timeCounter)
    }
    
    private static func makeGameActionsViewController(_ gameActionsHandler: GameActionsHandler) -> UIViewController {
        return GameActionsViewController.make(with: gameActionsHandler)
    }
    
    private static func makeGameViewController(
        gameStatsViewController: UIViewController,
        boardViewController: UIViewController,
        boardWidth: Double,
        gameActionsViewController: UIViewController,
        numpadViewController: UIViewController,
    ) -> UIViewController {
        return GameViewController(
            gameStatsViewController: gameStatsViewController,
            boardViewController: boardViewController,
            boardSizeWidth: boardWidth,
            gameActionsViewController: gameActionsViewController,
            numpadViewController: numpadViewController
        )
    }
    
    // Mark: run initial screen
    static func run(in window: UIWindow) {
        let game = SudokuGameGenerator().generateBoard(difficulty: .easy)
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(screenWidth: window.bounds.width)
        let gameService = GameService(game: game)
        let gameViewController = makeGameViewController(
            gameStatsViewController: makeGameStatsViewController(gameService, timeCounter: gameService),
            boardViewController: makeBoardViewController(
                sizeProvider,
                boardContentDataSource: gameService,
                interactionHandler: gameService
            ),
            boardWidth: sizeProvider.realContentWidth,
            gameActionsViewController: makeGameActionsViewController(gameService),
            numpadViewController: makeNumpadViewController(gameService)
        )
        let navigationViewController = UINavigationController(rootViewController: gameViewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
