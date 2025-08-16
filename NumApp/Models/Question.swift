//
//  Question.swift
//  NumApp
//
//  Created by GitHub Copilot on 8/15/25.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let firstOperand: Int
    let secondOperand: Int
    let answer: Int
    let solutionPositions: [GridPosition]
    var isSolved: Bool = false
    
    init(firstOperand: Int, secondOperand: Int, solutionPositions: [GridPosition]) {
        self.firstOperand = firstOperand
        self.secondOperand = secondOperand
        self.answer = firstOperand + secondOperand
        self.solutionPositions = solutionPositions
    }
    
    /// Create a question from a solution path in the grid
    static func createQuestion(from positions: [GridPosition], grid: [[Int]]) -> Question? {
        guard positions.count >= 1 else { return nil }
        
        let digits = positions.map { grid[$0.row][$0.col] }
        let answerString = digits.map { String($0) }.joined()
        guard let answer = Int(answerString) else { return nil }
        
        // Generate random operands that add up to this answer
        // Ensure we have a valid range for the first operand
        guard answer >= 2 else { return nil }
        let firstOperand = Int.random(in: 1...(answer - 1))
        let secondOperand = answer - firstOperand
        
        return Question(firstOperand: firstOperand, secondOperand: secondOperand, solutionPositions: positions)
    }
    
    /// Get the equation string representation
    var equationString: String {
        return "\(firstOperand) + \(secondOperand) = ?"
    }
    
    /// Get the solved equation string
    var solvedEquationString: String {
        return "\(firstOperand) + \(secondOperand) = \(answer)"
    }
}
