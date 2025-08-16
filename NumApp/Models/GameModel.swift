//
//  GameModel.swift
//  NumApp
//
//  Created by GitHub Copilot on 8/15/25.
//

import Foundation
import SwiftUI

@Observable
class GameModel {
    static let maxLevel = 10
    
    var gridModel = GridModel()
    var questions: [Question] = []
    var currentQuestionIndex = 0
    var level = 1
    var showingLevelCompleteAnimation = false
    var showingGameCompleteAnimation = false
    
    init() {
        generateNewLevel()
    }
    
    /// Generate a new level with 3 questions
    func generateNewLevel() {
        gridModel.generateNewGrid()
        questions = generateQuestions()
        currentQuestionIndex = 0
    }
    
    /// Generate 3 questions with guaranteed solutions
    private func generateQuestions() -> [Question] {
        var generatedQuestions: [Question] = []
        let maxAttempts = 100
        
        while generatedQuestions.count < 3 {
            var attempts = 0
            var questionGenerated = false
            
            while attempts < maxAttempts && !questionGenerated {
                if let question = generateRandomQuestion() {
                    // Make sure this question doesn't conflict with existing ones
                    let conflictsWithExisting = generatedQuestions.contains { existingQuestion in
                        hasOverlappingPositions(question.solutionPositions, existingQuestion.solutionPositions)
                    }
                    
                    if !conflictsWithExisting {
                        generatedQuestions.append(question)
                        questionGenerated = true
                    }
                }
                attempts += 1
            }
            
            // If we can't generate non-conflicting questions, regenerate the grid
            if !questionGenerated {
                gridModel.generateNewGrid()
                generatedQuestions.removeAll()
            }
        }
        
        return generatedQuestions
    }
    
    /// Generate a random question with a valid solution
    private func generateRandomQuestion() -> Question? {
        let directions = [
            (-1, -1), (-1, 0), (-1, 1),  // Up-left, Up, Up-right
            (0, -1),           (0, 1),   // Left, Right
            (1, -1),  (1, 0),  (1, 1)    // Down-left, Down, Down-right
        ]
        
        for _ in 0..<100 { // Try 100 random positions and lengths
            let startRow = Int.random(in: 0..<GridModel.gridSize)
            let startCol = Int.random(in: 0..<GridModel.gridSize)
            let direction = directions.randomElement()!
            let sequenceLength = Int.random(in: 1...3) // 1-3 digit answers
            
            // Try to create a digit sequence in this direction
            var positions: [GridPosition] = []
            var currentRow = startRow
            var currentCol = startCol
            
            for _ in 0..<sequenceLength {
                let position = GridPosition(currentRow, currentCol)
                if gridModel.isValidPosition(position) {
                    positions.append(position)
                    currentRow += direction.0
                    currentCol += direction.1
                } else {
                    break
                }
            }
            
            if positions.count == sequenceLength {
                if let question = Question.createQuestion(from: positions, grid: gridModel.grid) {
                    // Only accept answers between 10 and 99 for reasonable difficulty
                    if question.answer >= 10 && question.answer <= 99 {
                        return question
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Check if two sets of positions overlap
    private func hasOverlappingPositions(_ positions1: [GridPosition], _ positions2: [GridPosition]) -> Bool {
        let set1 = Set(positions1)
        let set2 = Set(positions2)
        return !set1.isDisjoint(with: set2)
    }
    
    /// Current question
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    /// Check if player's selection solves the current question
    func checkSolution() -> Bool {
        guard let question = currentQuestion else { return false }
        
        // Check if the selected digits form the correct answer
        if gridModel.doesSelectionFormNumber(question.answer) {
            // Mark question as solved
            questions[currentQuestionIndex].isSolved = true
            gridModel.clearSelection()
            
            // Move to next unsolved question
            advanceToNextQuestion()
            
            return true
        }
        
        return false
    }
    
    /// Advance to the next unsolved question
    private func advanceToNextQuestion() {
        // Find next unsolved question
        for i in 0..<questions.count {
            if !questions[i].isSolved {
                currentQuestionIndex = i
                return
            }
        }
        
        // All questions solved, show celebration then advance to next level or complete game
        if allQuestionsSolved {
            if level >= GameModel.maxLevel {
                // Game completed!
                showingGameCompleteAnimation = true
            } else {
                showingLevelCompleteAnimation = true
                // Delay advancing to next level to show animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.level += 1
                    self.showingLevelCompleteAnimation = false
                    self.generateNewLevel()
                }
            }
        }
    }
    
    /// Check if all questions are solved
    var allQuestionsSolved: Bool {
        return questions.allSatisfy { $0.isSolved }
    }
    
    /// Get progress (number of solved questions out of 5)
    var progress: (solved: Int, total: Int) {
        let solved = questions.filter { $0.isSolved }.count
        return (solved, questions.count)
    }
    
    /// Reset to beginning
    func reset() {
        level = 1
        showingLevelCompleteAnimation = false
        showingGameCompleteAnimation = false
        generateNewLevel()
    }
    
    /// Restart the game from level 1
    func restartGame() {
        reset()
    }
}
