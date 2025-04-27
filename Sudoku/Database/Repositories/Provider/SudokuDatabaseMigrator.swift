//
//  SudokuDatabaseMigrator.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import GRDB

protocol DatabaseSchemeMigrator {
    func migrate(_ databaseQueue: DatabaseQueue) throws
}

class SudokuDatabaseMigrator: DatabaseSchemeMigrator {
    private let migrator = {
        var migrator = DatabaseMigrator()
#if DEBUG
        // Speed up development by nuking the database when migrations change
        migrator.eraseDatabaseOnSchemaChange = true
#endif
        
        migrator.registerMigration("initialSchema") { db in
            try db.create(table: "sudokuGameModel") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("difficulty", .integer).notNull()
                table.column("time", .integer).notNull()
                table.column("mistakesCount", .integer).notNull()
                table.column("suggestionsCount", .integer).notNull()
                table.column("isSolved", .boolean).notNull()
                table.column("score", .integer).notNull()
            }
            
            try db.create(table: "sudokuGameItemModel") { table in
                table.autoIncrementedPrimaryKey("id")
                table.column("row", .integer).notNull()
                table.column("column", .integer).notNull()
                table.column("correctValue", .integer).notNull()
                table.column("value", .integer)
                table.column("isEditable", .boolean).notNull()
                table.belongsTo("game", inTable: "sudokuGameModel", onDelete: .cascade).notNull()//belongsTo("sudokuGameModel", onDelete: .cascade).notNull()
            }
        }
        return migrator
    }()
    
    func migrate(_ databaseQueue: DatabaseQueue) throws {
        try migrator.migrate(databaseQueue)
    }
}
