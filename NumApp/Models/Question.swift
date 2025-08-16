//
//  Question.swift
//  NumApp
//
//  Created by GitHub Copilot on 8/15/25.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let operands: [Int]
    let targetSum: Int
    let solutionPositions: [GridPosition]
    var isSolved: Bool = false
    
    init(operands: [Int], targetSum: Int, solutionPositions: [GridPosition]) {
        self.operands = operands
        self.targetSum = targetSum
        self.solutionPositions = solutionPositions
    }
    
    /// Create a question from a solution path in the grid
    static func createQuestion(from positions: [GridPosition], grid: [[Int]]) -> Question? {
        guard positions.count == 2 else { return nil }
        
        let operands = positions.map { grid[$0.row][$0.col] }
        let targetSum = operands.reduce(0, +)
        
        return Question(operands: operands, targetSum: targetSum, solutionPositions: positions)
    }
    
    /// Get the equation string representation
    var equationString: String {
        let operandStrings = operands.map { String($0) }
        return operandStrings.joined(separator: " + ") + " = ?"
    }
    
    /// Get the solved equation string
    var solvedEquationString: String {
        let operandStrings = operands.map { String($0) }
        return operandStrings.joined(separator: " + ") + " = \(targetSum)"
    }
}
