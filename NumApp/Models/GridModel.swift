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
    static let gridSize = 5
    
    var grid: [[Int]] = []
    var selectedPositions: [GridPosition] = []
    var isSelecting = false
    
    init() {
        generateNewGrid()
    }
    
    /// Generate a new random grid with numbers 0-99
    func generateNewGrid() {
        grid = (0..<GridModel.gridSize).map { _ in
            (0..<GridModel.gridSize).map { _ in
                Int.random(in: 0...99)
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
    
    /// Add position to selection if it forms a valid line
    func addToSelection(_ position: GridPosition) {
        guard isSelecting && isValidPosition(position) else { return }
        
        // Don't add if already selected
        if selectedPositions.contains(position) { return }
        
        // If this is the second position, just add it
        if selectedPositions.count == 1 {
            selectedPositions.append(position)
            return
        }
        
        // For two numbers only, don't allow more than 2 selections
        if selectedPositions.count >= 2 {
            return
        }
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
    
    /// Check if current selection matches a solution
    func doesSelectionMatch(solution: [GridPosition]) -> Bool {
        guard selectedPositions.count == 2 && solution.count == 2 else { return false }
        
        // Check forward direction
        if selectedPositions == solution { return true }
        
        // Check backward direction
        if selectedPositions == solution.reversed() { return true }
        
        return false
    }
}
