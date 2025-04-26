//
//  MockDatabaseQueueProvider.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 26.04.2025.
//

import Foundation
import GRDB
import Sudoku

class MockDatabaseQueueProvider: DatabaseQueueProvider {
    func databaseQueue() throws -> DatabaseQueue {
        return try DatabaseQueue()
    }
}
