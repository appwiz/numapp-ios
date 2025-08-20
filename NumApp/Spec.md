# iOS Numbers Game

A SwiftUI-based iOS game where players find digit sequences in a grid that form target numbers to solve addition equations.

## Game Description

This is an iOS app using Swift and SwiftUI. The game displays a 6x6 grid of single digits (0-9) along with math questions, presented one at a time. Each question shows an addition equation where players must find the answer by selecting digits in the grid that form the target number.

### Game Features

- **6x6 Grid**: Single digits (0-9) displayed in a grid with flat pastel color backgrounds for improved readability
- **3 Questions per Level**: Each question shows an equation like "45 + 23 = ?" where players find digits that form "68"
- **Multi-directional Solutions**: Solutions can be found horizontally, vertically, diagonally, and in both forward and backward directions
- **Touch & Drag Selection**: Players tap or drag their finger across adjacent cells to select digit sequences
- **Digit Sequence Formation**: Selected digits are concatenated to form multi-digit numbers (e.g., selecting 6, 8 forms "68")
- **Solution Validation**: The game validates that selected sequences form valid adjacent paths and match the target answer
- **Progress Tracking**: Visual progress indicator with colorful circles shows how many questions are solved (out of 3)
- **Level Progression**: Complete all 3 solutions to advance to the next level
- **5-Level Game**: Game consists of 5 levels total with increasing difficulty
- **Level Completion Animations**: Fireworks celebration when completing each level
- **Game Completion Celebration**: Full-screen spectacular animation with fireworks, dancing unicorns, and rainbows when all 5 levels are completed
- **Kid-Friendly UI**: Clean design with flat pastel colors for better number readability, emojis, animations, and haptic feedback

### Technical Implementation

The game consists of several key components:

#### Models
- **GridPosition**: Represents a position in the grid (row, col)
- **Question**: Contains operands, target sum, and solution positions
- **GridModel**: Manages the number grid and player selections
- **GameModel**: Handles game state, questions, and solution validation

#### Views
- **GameView**: Main game interface with progress, questions, and controls
- **GridView**: Displays the number grid with flat pastel color backgrounds and drag gesture support
- **QuestionView**: Shows current question with solved status
- **FireworksView**: Particle-based fireworks animation for celebrations
- **DancingUnicornsView**: Animated unicorn emojis that bounce around the screen
- **RainbowView**: Moving rainbow arcs animation

#### Grid Cell Styling
- **Flat Pastel Colors**: Uses 5 carefully chosen pastel colors for grid cell backgrounds to improve number readability
- **Color Palette**: Light pink, light green, light blue, light yellow, and light lavender
- **High Contrast Text**: Black text on pastel backgrounds ensures excellent readability
- **Selected State**: Orange highlight color for selected cells with clear visual feedback
- **Simplified Design**: Flat colors replace gradients for a cleaner, more accessible interface

#### Game Logic
- Random question generation with guaranteed solutions (1-3 digit answers)
- Adjacent path validation for digit sequences (horizontal, vertical, diagonal)
- Answer range validation (targets between 10-99 for reasonable difficulty)
- Conflict-free question generation (solutions don't overlap)
- Automatic progression to next unsolved question
- Grid regeneration for new levels with level counter (max 5 levels)
- Level completion detection with celebration triggers
- Game completion with full-screen animated celebration
- Restart functionality to replay from level 1

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

1. **Objective**: Find sequences of digits in the grid that form the answer to addition equations
2. **Selection**: Tap or drag your finger across adjacent digits to select them
3. **Valid Paths**: Selected digits must be adjacent to each other (including diagonally)
4. **Direction**: Selections can be made in any direction (horizontal, vertical, or diagonal)
5. **Number Formation**: Selected digits are concatenated in selection order to form the target number
6. **Completion**: Solve all 3 questions to advance to the next level
7. **Feedback**: Wrong selections trigger haptic feedback; correct solutions show celebrations
8. **Level Celebrations**: Fireworks animation plays when completing each level
9. **Game Victory**: Complete all 5 levels to trigger the ultimate celebration with fireworks, dancing unicorns, and rainbows
10. **Restart**: Use the "Play Again" button in the victory screen to restart from level 1

## Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 5.8+
