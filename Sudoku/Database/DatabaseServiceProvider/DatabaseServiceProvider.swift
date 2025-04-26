//
//  DatabaseServiceProvider.swift
//  Sudoku
//
//  Created by Illia Suvorov on 26.04.2025.
//

import Foundation
import GRDB

class DatabaseServiceProvider {
    let databaseQueueProvivder: DatabaseQueueProvider
    let migrator: DatabaseSchemeMigrator
    
    init(databaseQueueProvider: DatabaseQueueProvider, migrator: DatabaseSchemeMigrator) {
        self.databaseQueueProvivder = databaseQueueProvider
        self.migrator = migrator
    }
    
    func service() throws -> SudokuDatabaseService {
        let databaseQueue = try databaseQueueProvivder.databaseQueue()
        try migrator.migrate(databaseQueue)
        
        return try DatabaseService(databaseQueue: databaseQueue)
    }
}
