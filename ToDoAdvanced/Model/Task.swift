//
//  Task.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 06/01/2023.
//

import Foundation
import CoreData

struct Task: Identifiable {
    var id = UUID()
    var name: String?
    var type: String?
    var isDone: Bool
    var date: Date
    var time: Date
    var assigned: String?
    var details: String?
}

//class TaskViewModel: ObservableObject {
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    @Published var name: String
//    @Published var type: String
//    var types = ["Chores", "Cleaning", "Shopping", "Cooking"]
//    @Published var isDone: Bool
//    @Published var date: Date = Date.now
//    @Published private var isDated = false
//    var selectedDate = Date()
//    @Published var time: Date = Date.now
//    @Published private var isTimed = false
//    @Published var assigned: String
//    var assignedPeople = ["Me", "Harry", "Herminone", "Ron"]
//    @Published var details: String
//    
//    private func deleteItems(offsets: IndexSet) {
////        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//            
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
////        }
//    }
//}
