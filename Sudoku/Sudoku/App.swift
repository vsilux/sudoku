//
//  App.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import UIKit

enum App {
    private static func makeBoardViewController(_ sizeProvider: SudokuBoardSizeProvider, boardContentDataSource: SudokuBoardConentDataSource) -> UIViewController {
        return SudokuBoardViewController(
            collectionViewLayout: SudokuLayout(sizeProvider: sizeProvider),
            backgroundViewBuilder: SudokuCollectionViewBackgrounViewBuilder(sizeProvider: sizeProvider),
            boardContentDataSource: boardContentDataSource
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
        let gameController = GameController(game: SudokuGameGenerator().generateBoard())
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(screenWidth: window.bounds.width)
        let gameViewController = makeGameViewController(
            boardViewController: makeBoardViewController(
                sizeProvider,
                boardContentDataSource: gameController
            ),
            boardWidth: sizeProvider.realContentWidth,
            numpadViewController: makeNumpadViewController(gameController)
        )
        let navigationViewController = UINavigationController(rootViewController: gameViewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
