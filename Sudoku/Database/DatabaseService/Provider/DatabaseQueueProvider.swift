//
//  DatabaseQueueProvider.swift
//  Sudoku
//
//  Created by Illia Suvorov on 25.04.2025.
//

import UIKit
import GRDB

public protocol DatabaseQueueProvider {
    func databaseQueue() throws -> DatabaseQueue
}

class SQLiteDataBaseQueueProvider: DatabaseQueueProvider {
    func databaseQueue() throws -> DatabaseQueue {
        let appSupportURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directoryURL = appSupportURL
            .appendingPathComponent("SudokuDatabase")
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        let dbQueue = try DatabaseQueue(path: directoryURL.appendingPathComponent("Sudoku.sqlite").path)
        
        return dbQueue
    }
}
