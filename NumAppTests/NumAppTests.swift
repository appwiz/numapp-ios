//
//  NumAppTests.swift
//  NumAppTests
//
//  Created by Rohan Deshpande on 8/15/25.
//

import Testing
@testable import NumApp

struct NumAppTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testGridSizeIs6x6() async throws {
        // Test that the grid size is now 6x6
        #expect(GridModel.gridSize == 6)
        
        let gridModel = GridModel()
        #expect(gridModel.grid.count == 6)
        for row in gridModel.grid {
            #expect(row.count == 6)
        }
    }

}
