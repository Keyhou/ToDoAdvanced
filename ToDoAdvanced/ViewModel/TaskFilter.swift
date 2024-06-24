//
//  TaskFilter.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 20/06/2023.
//

//import Foundation
//import SwiftUI

//enum TaskFilter: String {
//    static var allFilters: [TaskFilter] {
//        return [.Done, .ToDo, .All]
//    }
//    case All = "All"
//    case ToDo = "ToDo"
//    case Done = "Completed"
//}


//enum TaskFilter: String {
//    case All = "All"
//    case ToDo = "ToDo"
//    case Done = "Done"
//}


import SwiftUI
import CoreData
//import UserNotifications

enum TaskFilter: String, CaseIterable {
    case ToDo = "ToDo"
    case All = "All"
    case Done = "Done"
}
