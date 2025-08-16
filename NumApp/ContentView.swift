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
        VStack(spacing: 25) {
            // Header with level and progress
            VStack(spacing: 15) {
                Text("🔢 Numbers Game 🎯")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack {
                    Text("🌟")
                        .font(.title2)
                    Text("Level \(gameModel.level)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    Text("🌟")
                        .font(.title2)
                }
                
                // Progress indicator with fun colors and New Level button
                HStack {
                    VStack(spacing: 8) {
                        Text("Progress: \(gameModel.progress.solved)/3")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(index < gameModel.progress.solved ?
                                         LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom) :
                                         LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                            .opacity(index < gameModel.progress.solved ? 1 : 0)
                                    )
                                    .scaleEffect(index < gameModel.progress.solved ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: gameModel.progress.solved)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // New Level button moved next to progress
                    Button(action: {
                        gameModel.generateNewLevel()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.title3)
                            Text("Restart Level")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Current question with colorful background
            if let question = gameModel.currentQuestion {
                QuestionView(question: question, gameModel: gameModel)
                    .padding(.horizontal, 20)
            }
            
            // Grid with improved styling
            GridView(gameModel: gameModel)
                .padding(.horizontal, 20)
            
            // Controls with kid-friendly styling
            VStack(spacing: 15) {
                HStack(spacing: 20) {
                    Button(action: {
                        gameModel.gridModel.clearSelection()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3)
                            Text("Clear")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(gameModel.gridModel.selectedPositions.isEmpty)
                    .opacity(gameModel.gridModel.selectedPositions.isEmpty ? 0.6 : 1.0)
                    
                    Button(action: {
                        let isCorrect = gameModel.checkSolution()
                        if !isCorrect {
                            // Add haptic feedback for wrong answers
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                            Text("Check!")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(gameModel.gridModel.selectedPositions.isEmpty)
                    .opacity(gameModel.gridModel.selectedPositions.isEmpty ? 0.6 : 1.0)
                    .scaleEffect(gameModel.gridModel.selectedPositions.isEmpty ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: gameModel.gridModel.selectedPositions.isEmpty)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color.blue.opacity(0.05),
                    Color.purple.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            // Level completion celebration
            Group {
                if gameModel.showingLevelCompleteAnimation {
                    ZStack {
                        // Semi-transparent overlay
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        // Fireworks animation
                        FireworksView()
                            .ignoresSafeArea()
                        
                        // Celebration text
                        VStack(spacing: 20) {
                            Text("🎉 LEVEL COMPLETE! 🎉")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                .scaleEffect(gameModel.showingLevelCompleteAnimation ? 1.2 : 1.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).repeatCount(3, autoreverses: true), value: gameModel.showingLevelCompleteAnimation)
                            
                            Text("🌟 Moving to Level \(gameModel.level + 1) 🌟")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .stroke(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                // Game completion celebration
                if gameModel.showingGameCompleteAnimation {
                    ZStack {
                        // Full screen background
                        LinearGradient(
                            colors: [.purple, .pink, .orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        // Rainbow background
                        RainbowView()
                            .ignoresSafeArea()
                        
                        // Fireworks
                        FireworksView()
                            .ignoresSafeArea()
                        
                        // Dancing unicorns
                        DancingUnicornsView()
                            .ignoresSafeArea()
                        
                        // Victory content
                        VStack(spacing: 40) {
                            VStack(spacing: 20) {
                                Text("🎉🦄🌈 YOU WON! 🌈🦄🎉")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .yellow, .white],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                                    .multilineTextAlignment(.center)
                                    .scaleEffect(gameModel.showingGameCompleteAnimation ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).repeatCount(5, autoreverses: true), value: gameModel.showingGameCompleteAnimation)
                                
                                Text("🏆 CONGRATULATIONS! 🏆")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                                
                                Text("You completed all 5 levels!")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            }
                            
                            Button(action: {
                                gameModel.restartGame()
                            }) {
                                HStack(spacing: 15) {
                                    Text("🚀")
                                        .font(.title2)
                                    Text("Play Again")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("🚀")
                                        .font(.title2)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [.green, .blue, .purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .orange],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 4
                                        )
                                )
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                .scaleEffect(1.1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(40)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                                    LinearGradient(
                                        colors: [.black.opacity(0.3), .black.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, .yellow, .white],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
        )
    }
}

struct QuestionView: View {
    let question: Question
    let gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🧮")
                    .font(.title2)
                Text("Find digits that form the answer:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.indigo)
                Text("🔍")
                    .font(.title2)
            }
            
            Text(displayEquation)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(
                    question.isSolved ?
                    LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                )
                .monospaced()
                .padding(.vertical, 8)
            
            if question.isSolved {
                HStack {
                    Text("🎉")
                        .font(.title)
                    Text("Awesome! You got it!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("🎉")
                        .font(.title)
                }
                .scaleEffect(1.1)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: question.isSolved)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    question.isSolved ?
                    LinearGradient(colors: [.green.opacity(0.1), .mint.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                    LinearGradient(colors: [.blue.opacity(0.05), .purple.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .stroke(
                    question.isSolved ?
                    LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .leading, endPoint: .trailing),
                    lineWidth: 2
                )
        )
        .shadow(color: question.isSolved ? .green.opacity(0.2) : .blue.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var displayEquation: String {
        if question.isSolved {
            return question.solvedEquationString
        } else {
            let selectedDigits = gameModel.gridModel.selectedValues
            if selectedDigits.isEmpty {
                return question.equationString
            } else {
                let selectedNumber = selectedDigits.map { String($0) }.joined()
                return "\(question.firstOperand) + \(question.secondOperand) = \(selectedNumber)"
            }
        }
    }
}

struct GridView: View {
    @Bindable var gameModel: GameModel
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<GridModel.gridSize, id: \.self) { row in
                HStack(spacing: 4) {
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
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .blue.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct GridCellView: View {
    let value: Int
    let isSelected: Bool
    let position: GridPosition
    @Bindable var gameModel: GameModel
    
    // Fun colors for different digits
    private var cellColor: Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .mint, .cyan, .blue, .indigo, .purple, .pink]
        return colors[value % colors.count]
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    isSelected ?
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [.white, cellColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(
                    isSelected ?
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [cellColor.opacity(0.4), cellColor.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: isSelected ? 3 : 2
                )
                .shadow(
                    color: isSelected ? .orange.opacity(0.4) : cellColor.opacity(0.2),
                    radius: isSelected ? 6 : 3,
                    x: 0,
                    y: isSelected ? 3 : 2
                )
            
            Text("\(value)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(
                    isSelected ? .white :
                    (value == 0 ? .gray : cellColor.opacity(0.8))
                )
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .frame(width: 50, height: 50)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        .onTapGesture {
            handleCellInteraction()
            // Add haptic feedback for taps
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    handleCellInteraction()
                }
                .onEnded { _ in
                    gameModel.gridModel.endSelection()
                }
        )
    }
    
    private func handleCellInteraction() {
        if !gameModel.gridModel.isSelecting {
            gameModel.gridModel.startSelection(at: position)
        } else {
            gameModel.gridModel.addToSelection(position)
        }
    }
}

struct FireworksView: View {
    @State private var particles: [FireworkParticle] = []
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            startFireworks()
        }
        .onDisappear {
            stopFireworks()
        }
    }
    
    private func startFireworks() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            createFireworkBurst()
            updateParticles()
        }
    }
    
    private func stopFireworks() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func createFireworkBurst() {
        let centerX = CGFloat.random(in: 100...300)
        let centerY = CGFloat.random(in: 150...400)
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .mint, .cyan]
        
        for _ in 0..<12 {
            let angle = Double.random(in: 0...(2 * .pi))
            let velocity = CGFloat.random(in: 50...120)
            let color = colors.randomElement() ?? .yellow
            
            let particle = FireworkParticle(
                position: CGPoint(x: centerX, y: centerY),
                velocity: CGPoint(
                    x: CGFloat(cos(angle)) * velocity,
                    y: CGFloat(sin(angle)) * velocity
                ),
                color: color,
                size: CGFloat.random(in: 4...12),
                opacity: 1.0,
                scale: 1.0,
                lifespan: Double.random(in: 1.0...2.5)
            )
            particles.append(particle)
        }
    }
    
    private func updateParticles() {
        particles = particles.compactMap { particle in
            var updatedParticle = particle
            updatedParticle.position.x += particle.velocity.x * 0.1
            updatedParticle.position.y += particle.velocity.y * 0.1
            updatedParticle.velocity.y += 50 * 0.1 // gravity
            updatedParticle.lifespan -= 0.1
            updatedParticle.opacity = max(0, updatedParticle.lifespan / 2.0)
            updatedParticle.scale = 1.0 + (2.0 - updatedParticle.lifespan) * 0.5
            
            return updatedParticle.lifespan > 0 ? updatedParticle : nil
        }
    }
}

struct FireworkParticle {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
    var scale: CGFloat
    var lifespan: Double
}

struct DancingUnicornsView: View {
    @State private var unicorns: [DancingUnicorn] = []
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(unicorns, id: \.id) { unicorn in
                Text("🦄")
                    .font(.system(size: unicorn.size))
                    .position(unicorn.position)
                    .rotationEffect(.degrees(unicorn.rotation))
                    .scaleEffect(unicorn.scale)
                    .opacity(unicorn.opacity)
            }
        }
        .onAppear {
            startUnicornDance()
        }
        .onDisappear {
            stopUnicornDance()
        }
    }
    
    private func startUnicornDance() {
        // Create initial unicorns
        for _ in 0..<6 {
            createUnicorn()
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateUnicorns()
            if unicorns.count < 8 && Double.random(in: 0...1) < 0.3 {
                createUnicorn()
            }
        }
    }
    
    private func stopUnicornDance() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func createUnicorn() {
        let unicorn = DancingUnicorn(
            position: CGPoint(
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 200...600)
            ),
            velocity: CGPoint(
                x: CGFloat.random(in: -30...30),
                y: CGFloat.random(in: -50...50)
            ),
            size: CGFloat.random(in: 30...60),
            rotation: 0,
            rotationSpeed: Double.random(in: -180...180),
            scale: 1.0,
            opacity: 1.0,
            lifespan: Double.random(in: 3.0...6.0)
        )
        unicorns.append(unicorn)
    }
    
    private func updateUnicorns() {
        unicorns = unicorns.compactMap { unicorn in
            var updated = unicorn
            updated.position.x += unicorn.velocity.x * 0.1
            updated.position.y += unicorn.velocity.y * 0.1
            updated.rotation += unicorn.rotationSpeed * 0.1
            updated.lifespan -= 0.1
            updated.opacity = max(0, updated.lifespan / 3.0)
            updated.scale = 1.0 + sin(updated.lifespan * 2) * 0.2
            
            // Bounce off edges
            if updated.position.x < 0 || updated.position.x > 400 {
                updated.velocity.x *= -1
            }
            if updated.position.y < 100 || updated.position.y > 700 {
                updated.velocity.y *= -1
            }
            
            return updated.lifespan > 0 ? updated : nil
        }
    }
}

struct DancingUnicorn {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let size: CGFloat
    var rotation: Double
    let rotationSpeed: Double
    var scale: CGFloat
    var opacity: Double
    var lifespan: Double
}

struct RainbowView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Multiple rainbow arcs
            ForEach(0..<3, id: \.self) { index in
                RainbowArc(offset: animationOffset + CGFloat(index) * 100)
                    .opacity(0.8)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                animationOffset = 400
            }
        }
    }
}

struct RainbowArc: View {
    let offset: CGFloat
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 200, y: 400)
            let radius: CGFloat = 150
            path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
        }
        .stroke(
            LinearGradient(
                colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                startPoint: .leading,
                endPoint: .trailing
            ),
            lineWidth: 20
        )
        .offset(x: offset)
    }
}

#Preview {
    ContentView()
}
