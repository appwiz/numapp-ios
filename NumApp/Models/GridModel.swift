//
//  GridModel.swift
//  NumApp
//
//  Created by GitHub Copilot on 8/15/25.
//

import Foundation
import SwiftUI

@Observable
class GridModel {
    static let gridSize = 6
    
    var grid: [[Int]] = []
    var selectedPositions: [GridPosition] = []
    var isSelecting = false
    
    init() {
        generateNewGrid()
    }
    
    /// Generate a new random grid with single digits 0-9
    func generateNewGrid() {
        grid = (0..<GridModel.gridSize).map { _ in
            (0..<GridModel.gridSize).map { _ in
                Int.random(in: 0...9)
            }
        }
        selectedPositions.removeAll()
    }
    
    /// Get value at position
    func getValue(at position: GridPosition) -> Int? {
        guard isValidPosition(position) else { return nil }
        return grid[position.row][position.col]
    }
    
    /// Check if position is valid
    func isValidPosition(_ position: GridPosition) -> Bool {
        return position.row >= 0 && position.row < GridModel.gridSize &&
               position.col >= 0 && position.col < GridModel.gridSize
    }
    
    /// Start selection at position
    func startSelection(at position: GridPosition) {
        guard isValidPosition(position) else { return }
        selectedPositions = [position]
        isSelecting = true
    }
    
    /// Add position to selection if it's adjacent to the last selected position
    func addToSelection(_ position: GridPosition) {
        guard isSelecting && isValidPosition(position) else { return }
        
        // Don't add if already selected
        if selectedPositions.contains(position) { return }
        
        // Check if position is adjacent to the last selected position
        if let lastPosition = selectedPositions.last {
            if !lastPosition.isAdjacent(to: position) {
                return // Not adjacent, don't add
            }
        }
        
        selectedPositions.append(position)
    }
    
    /// End selection
    func endSelection() {
        isSelecting = false
    }
    
    /// Clear selection
    func clearSelection() {
        selectedPositions.removeAll()
        isSelecting = false
    }
    
    /// Check if position extends the current line
    private func isValidLineExtension(_ position: GridPosition) -> Bool {
        guard selectedPositions.count >= 2 else { return true }
        
        let lastTwo = Array(selectedPositions.suffix(2))
        let direction = lastTwo[0].direction(to: lastTwo[1])
        let expectedNext = GridPosition(
            lastTwo[1].row + direction.row,
            lastTwo[1].col + direction.col
        )
        
        return position == expectedNext
    }
    
    /// Get selected values
    var selectedValues: [Int] {
        return selectedPositions.compactMap { getValue(at: $0) }
    }
    
    /// Get sum of selected values
    var selectedSum: Int {
        return selectedValues.reduce(0, +)
    }
    
    /// Get the number formed by selected digits
    var selectedNumber: Int {
        let digits = selectedValues.map { String($0) }.joined()
        return Int(digits) ?? 0
    }
    
    /// Check if current selection forms the target number
    func doesSelectionFormNumber(_ targetNumber: Int) -> Bool {
        return selectedNumber == targetNumber
    }
}
