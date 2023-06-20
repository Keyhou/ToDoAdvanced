//
//  TaskFilter.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 20/06/2023.
//

import Foundation
import SwiftUI

enum TaskFilter: String {
    static var allFilters: [TaskFilter] {
        return [.Done, .ToDo, .All]
    }
    case All = "All"
    case ToDo = "ToDo"
    case Done = "Completed"
}
