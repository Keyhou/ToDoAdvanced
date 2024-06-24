//
//  TaskViewModel.swift
//  ToDoAdvanced
//
//  Created by Keyhou on 31/05/2023.
//

//import Foundation 
//import SwiftUI
//import CoreData
//
//class TaskViewModel: ObservableObject {
//    @Published var date = Date()
//    @Published var items: [Item] = []
//    
//    let container = PersistenceController.shared.container
//    
//    init() {
//        fecthTasks()
//    }
//    
//    func fecthTasks() {
//        let request = NSFetchRequest<Item>(entityName: "item")
//        request.sortDescriptors = sortOrder()
//        
//        do {
//            items = try container.viewContext.fetch(request)
//        }
//        catch let error {
//            fatalError("Unresolved error \(error)")
//        }
//    }
//    
//    private func sortOrder() -> [NSSortDescriptor] {
//        let dateSort = NSSortDescriptor(keyPath: \Item.date, ascending: true)
//        let timeSort = NSSortDescriptor(keyPath: \Item.time, ascending: true)
////        let dueDateSort = NSSortDescriptor(keyPath: \Item.dueDate, ascending: true)
//        
////        return [completedDateSort, timeSort, dueDateSort]
//        return [dateSort, timeSort]
//    }
//    
//    
//    func saveContext(_ context: NSManagedObjectContext) {
//        do {
//            try context.save()
//            fecthTasks()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}


import Foundation
import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var date = Date()
    @Published var items: [Item] = []
    @Published var selectedFilter: TaskFilter = .All
    
    let container = PersistenceController.shared.container
    
    init() {
        fetchTasks()
    }
    
    func fetchTasks() {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = sortOrder()
        
        switch selectedFilter {
        case .All:
            request.predicate = nil
        case .ToDo:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        case .Done:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        }
        
        do {
            items = try container.viewContext.fetch(request)
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let dateSort = NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        return [dateSort]
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            fetchTasks()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
