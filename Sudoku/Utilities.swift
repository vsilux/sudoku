//
//  Utilities.swift
//  Sudoku
//
//  Created by Illia Suvorov on 22.04.2025.
//

import Foundation

enum Utilities {
    static func formattedScore(_ score: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        return formatter.string(for: score) ?? "\(score)"
    }
    
    static func formatToMinutesAndSeconds(_ seconds: Int) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
