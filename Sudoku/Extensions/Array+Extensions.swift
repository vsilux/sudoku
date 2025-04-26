//
//  Array.swift
//  Sudoku
//
//  Created by Illia Suvorov on 26.04.2025.
//

import Foundation

extension Array {
    func chopped(_ chopSize: Int) -> [[Element]] {
        var result: [[Element]] = []
        
        for i in stride(from: 0, to: count, by: chopSize) {
            let end = Swift.min(i + chopSize, count)
            let chunk = Array(self[i..<end])
            result.append(chunk)
        }
        return result
    }
}
