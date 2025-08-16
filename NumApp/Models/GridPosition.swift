//
//  GridPosition.swift
//  NumApp
//
//  Created by GitHub Copilot on 8/15/25.
//

import Foundation

struct GridPosition: Hashable, Codable {
    let row: Int
    let col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

extension GridPosition {
    /// Check if this position is adjacent to another position (including diagonally)
    func isAdjacent(to other: GridPosition) -> Bool {
        let rowDiff = abs(self.row - other.row)
        let colDiff = abs(self.col - other.col)
        return rowDiff <= 1 && colDiff <= 1 && !(rowDiff == 0 && colDiff == 0)
    }
    
    /// Get the direction vector from this position to another
    func direction(to other: GridPosition) -> (row: Int, col: Int) {
        let rowDiff = other.row - self.row
        let colDiff = other.col - self.col
        
        // Normalize to -1, 0, or 1
        let normalizedRow = rowDiff == 0 ? 0 : (rowDiff > 0 ? 1 : -1)
        let normalizedCol = colDiff == 0 ? 0 : (colDiff > 0 ? 1 : -1)
        
        return (normalizedRow, normalizedCol)
    }
}