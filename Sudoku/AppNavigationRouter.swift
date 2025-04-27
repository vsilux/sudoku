//
//  App.swift
//  Sudoku
//
//  Created by Illia Suvorov on 14.04.2025.
//

import UIKit

class AppNavigationRouter {
    let window: UIWindow
    let sceneEventStream: SceneEventStream
    
    init(window: UIWindow, sceneEventStream: SceneEventStream) {
        self.window = window
        self.sceneEventStream = sceneEventStream
    }
    
    func start() {
        do {
            let repositoryProvider = try SudokuRepositoriesProvider(
                databaseQueueProvider: SQLiteDataBaseQueueProvider(),
                migrator: SudokuDatabaseMigrator()
            )
            let router = MainMenuNavigationRouter(
                repositoryProvider: repositoryProvider,
                scenEventStream: sceneEventStream,
                gameGenerator: SudokuGameGenerator(repositoryProvider: repositoryProvider),
                windowBoundsProvider: self
            )
            
            let mainMenuStoryboard = UIStoryboard(name: "MainMenu", bundle: nil)
            let mainMenuViewController = mainMenuStoryboard.instantiateInitialViewController() as! MainMenuViewController
            mainMenuViewController.router = router
            mainMenuViewController.repository = repositoryProvider.gameRepository()
            
            let navigationViewController = UINavigationController(
                rootViewController: mainMenuViewController
            )
            
            router.navigationController = navigationViewController
            window.rootViewController = navigationViewController
            window.makeKeyAndVisible()
        } catch {
            print("Error: \(error)")
            // TODO: Run App error handling
        }
    }
}

extension AppNavigationRouter: WindowBoundsProvider {
    var bounds: CGRect {
        window.bounds
    }
}
