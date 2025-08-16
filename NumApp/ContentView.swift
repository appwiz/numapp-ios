//
//  ContentView.swift
//  NumApp
//
//  Created by Rohan Deshpande on 8/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var gameModel = GameModel()
    
    var body: some View {
        GameView(gameModel: gameModel)
    }
}

struct GameView: View {
    @Bindable var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with level and progress
            VStack(spacing: 10) {
                Text("Numbers Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Level \(gameModel.level)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Progress indicator
                HStack {
                    Text("Progress:")
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(index < gameModel.progress.solved ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                    }
                    Text("\(gameModel.progress.solved)/5")
                }
                .font(.caption)
            }
            .padding()
            
            // Current question
            if let question = gameModel.currentQuestion {
                QuestionView(question: question)
                    .padding(.horizontal)
            }
            
            // Grid
            GridView(gameModel: gameModel)
                .padding()
            
            // Controls
            HStack(spacing: 20) {
                Button("Clear Selection") {
                    gameModel.gridModel.clearSelection()
                }
                .disabled(gameModel.gridModel.selectedPositions.isEmpty)
                
                Button("Check Solution") {
                    let isCorrect = gameModel.checkSolution()
                    if !isCorrect {
                        // Could add haptic feedback or visual feedback here
                    }
                }
                .disabled(gameModel.gridModel.selectedPositions.count != 2)
                .buttonStyle(.borderedProminent)
                
                Button("New Level") {
                    gameModel.generateNewLevel()
                }
            }
            .padding()
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct QuestionView: View {
    let question: Question
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Find two numbers that add up to:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(question.isSolved ? question.solvedEquationString : question.equationString)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(question.isSolved ? .green : .primary)
                .monospaced()
            
            if question.isSolved {
                Text("✓ Solved!")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(question.isSolved ? Color.green.opacity(0.1) : Color(.systemBackground))
                .stroke(question.isSolved ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct GridView: View {
    @Bindable var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<GridModel.gridSize, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<GridModel.gridSize, id: \.self) { col in
                        let position = GridPosition(row, col)
                        let isSelected = gameModel.gridModel.selectedPositions.contains(position)
                        let value = gameModel.gridModel.grid[row][col]
                        
                        GridCellView(
                            value: value,
                            isSelected: isSelected,
                            position: position,
                            gameModel: gameModel
                        )
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct GridCellView: View {
    let value: Int
    let isSelected: Bool
    let position: GridPosition
    @Bindable var gameModel: GameModel
    
    var body: some View {
        Text("\(value)")
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .frame(width: 32, height: 32)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.blue : Color.white)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !gameModel.gridModel.isSelecting {
                            gameModel.gridModel.startSelection(at: position)
                        } else {
                            gameModel.gridModel.addToSelection(position)
                        }
                    }
                    .onEnded { _ in
                        gameModel.gridModel.endSelection()
                    }
            )
    }
}

#Preview {
    ContentView()
}
