# iOS Numbers Game

A SwiftUI-based iOS game where players find number sequences in a grid that add up to target values.

## Game Description

This is an iOS app using Swift and SwiftUI. The game displays a grid of numbers along with five math questions, presented one at a time. Each question requires players to find two numbers in the grid that add up to a target sum.

### Game Features

- **5x5 Grid**: Numbers ranging from 0-99 displayed in a grid
- **5 Questions per Level**: Each question shows an equation like "45 + 23 = ?"
- **Multi-directional Solutions**: Solutions can be found horizontally, vertically, diagonally, and in both forward and backward directions
- **Drag Selection**: Players drag their finger across the screen to select number sequences
- **Solution Validation**: The game validates that selected sequences form valid lines and sum to the target
- **Progress Tracking**: Visual progress indicator shows how many questions are solved
- **Level Progression**: Complete all 5 solutions to advance to the next grid

### Technical Implementation

The game consists of several key components:

#### Models
- **GridPosition**: Represents a position in the grid (row, col)
- **Question**: Contains operands, target sum, and solution positions
- **GridModel**: Manages the number grid and player selections
- **GameModel**: Handles game state, questions, and solution validation

#### Views
- **GameView**: Main game interface with progress, questions, and controls
- **GridView**: Displays the number grid with drag gesture support
- **QuestionView**: Shows current question with solved status

#### Game Logic
- Random question generation with guaranteed solutions
- Path validation for line-based selections (no zigzag patterns)
- Automatic progression to next unsolved question
- Grid regeneration for new levels

## Project Structure

```
NumApp/
├── NumAppApp.swift                 # iOS app entry point
├── ContentView.swift               # SwiftUI views and game UI
├── Spec.md                        # Game specification
├── Assets.xcassets/               # App assets
└── Models/
    ├── GridPosition.swift         # Grid position utilities
    ├── Question.swift             # Question data model
    ├── GridModel.swift            # Grid state management
    └── GameModel.swift            # Game logic and state
```

## Building and Running

### iOS App
Open `NumApp.xcodeproj` in Xcode to build and run the iOS app.

## Game Rules

1. **Objective**: Find sequences of 2 numbers in the grid that add up to the target sum
2. **Selection**: Drag your finger across numbers to select them
3. **Valid Paths**: Selected numbers must be adjacent to each other
4. **Direction**: Selections can be made in any direction (horizontal, vertical, or diagonal)
5. **Completion**: Solve all 5 questions to advance to the next level

## Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 5.8+
