//
//  Item.swift
//  NumApp
//
//  Created by Rohan Deshpande on 8/15/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
