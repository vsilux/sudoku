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
    
    private static func makeGameViewController(_ sizeProvider: SudokuBoardSizeProvider, boardContentDataSource: SudokuBoardConentDataSource) -> UIViewController {
        return GameViewController(
            boardViewController: makeBoardViewController(sizeProvider, boardContentDataSource: boardContentDataSource),
            boardSizeWidth: sizeProvider.realContentWidth
        )
    }
    
    // Mark: run initial screen
    static func run(in window: UIWindow) {
        let gameController = GameController(game: SudokuGameGenerator().generateBoard())
        let sizeProvider = SudokuBoardScreenBasedSizeProvider(screenWidth: window.bounds.width)
        let gameViewController = makeGameViewController(sizeProvider, boardContentDataSource: gameController)
        let navigationViewController = UINavigationController(rootViewController: gameViewController)
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}
