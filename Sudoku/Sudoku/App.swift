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
    
    private static func makeGameViewController(
        boardViewController: UIViewController,
        boardWidth: Double,
        numpadViewController: UIViewController,
    ) -> UIViewController {
        return GameViewController(
            boardViewController: boardViewController,
            boardSizeWidth: boardWidth,
            numpadViewController: numpadViewController
        )
    }
    
    // Mark: run initial screen
    static func run(in window: UIWindow) {
        let game = SudokuGameGenerator().generateBoard(difficulty: .easy)
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(screenWidth: window.bounds.width)
        let gameInteractionService = GameInteractionService(game: game)
        let gameViewController = makeGameViewController(
            boardViewController: makeBoardViewController(
                sizeProvider,
                boardContentDataSource: gameInteractionService,
                interactionHandler: gameInteractionService
            ),
            boardWidth: sizeProvider.realContentWidth,
            numpadViewController: makeNumpadViewController(gameInteractionService)
        )
        let navigationViewController = UINavigationController(rootViewController: gameViewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
