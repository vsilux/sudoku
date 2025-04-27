//
//  SydokuRepositoriesProvider.swift
//  SudokuTests
//
//  Created by Illia Suvorov on 27.04.2025.
//

import XCTest
@testable import Sudoku

final class SudokuRepositoriesProviderTests: XCTestCase {

    func test_SudokuRepositoriesProvider_initialized() {
        do {
            let _ = try SudokuRepositoriesProvider(databaseQueueProvider: MockDatabaseQueueProvider(), migrator: SudokuDatabaseMigrator())
        } catch {
            XCTFail("Failed to initialize SudokuRepositoriesProvider: \(error)")
        }
    }
}
