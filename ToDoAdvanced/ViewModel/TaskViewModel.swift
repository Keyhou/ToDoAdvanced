//
//  TaskViewModel.swift
//  ToDoAdvanced
//
//  Created by Keyhou on 31/05/2023.
//

//import Foundation
//import SwiftUI
//import CoreData
//import UserNotifications
//
//
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
//        let completedDateSort = NSSortDescriptor(keyPath: \Item.completedDate, ascending: true)
//        let timeSort = NSSortDescriptor(keyPath: \Item.scheduleTime, ascending: true)
//        let dueDateSort = NSSortDescriptor(keyPath: \Item.dueDate, ascending: true)
//        
//        return [completedDateSort, timeSort, dueDateSort]
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
