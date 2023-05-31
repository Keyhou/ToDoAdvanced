//
//  ItemExtension.swift
//  ToDoAdvanced
//
//  Created by Keyhou on 31/05/2023.
//

import Foundation
import SwiftUI

extension Item {
    
    func isCompleted() -> Bool {
        return date != nil
    }
    
//    func isOverdue() -> Bool {
//        if let reminder = time {
//            return !isCompleted() && scheduleTime && due < Date()
//        }
//        return false
//    }
//
//    func overdureColor() -> Color {
//        return isOverdue() ? .red : .primary
//    }
    
    func isHighPriority() -> Bool {
        return priority == "High"
    }
    func isNormalPriority() -> Bool {
        return priority == "Normal"
    }
    func isLowPriority() -> Bool {
        return priority == "Low"
    }
    
}
