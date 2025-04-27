//
//  DatabaseServiceProvider.swift
//  Sudoku
//
//  Created by Illia Suvorov on 26.04.2025.
//

import Foundation
import GRDB

protocol RepositoryProvider {
    func gameRepository() -> GameRepository
    func gameItemRepository() -> GameItemRepository
}

class SudokuRepositoriesProvider: RepositoryProvider {
    let databaseQueueProvivder: DatabaseQueueProvider
    let migrator: DatabaseSchemeMigrator
    private var databaseQueue: DatabaseQueue
    
    init(
        databaseQueueProvider: DatabaseQueueProvider,
        migrator: DatabaseSchemeMigrator
    ) throws {
        self.databaseQueueProvivder = databaseQueueProvider
        self.migrator = migrator
        
        databaseQueue = try databaseQueueProvivder.databaseQueue()
        try migrator.migrate(databaseQueue)
    }
    
    func gameRepository() -> GameRepository {
        SudokuGameRepository(databaseQueue: databaseQueue)
    }
    
    func gameItemRepository() -> GameItemRepository {
        SudokuGameItemRepository(databaseQueue: databaseQueue)
    }
}
