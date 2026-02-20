//
//  Item.swift
//  ProfileManagment-V1
//
//  Created by Mac Mini on 20/02/2026.
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
