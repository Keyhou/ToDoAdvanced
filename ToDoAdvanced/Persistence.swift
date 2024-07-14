//
//  Persistence.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  static var preview: PersistenceController = {
      let result = PersistenceController(inMemory: true)
      let viewContext = result.container.viewContext
      
      for i in 0..<1 {
          let newItem = Item(context: viewContext)
          newItem.timestamp = Date()
          newItem.name = "Sample Task \(i)"
          newItem.type = "Task"
          newItem.isDone = (i % 2 == 0)
          newItem.date = Date()
          newItem.time = Date()
          newItem.assigned = "Me"
          newItem.details = "Details for sample task \(i)"
      }
      
      do {
          try viewContext.save()
      } catch {
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      return result
  }()

  let container: NSPersistentCloudKitContainer

  init(inMemory: Bool = false) {
      container = NSPersistentCloudKitContainer(name: "ToDoAdvanced")
      if inMemory {
          container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      container.viewContext.automaticallyMergesChangesFromParent = true

      // Check if this is the first launch
      if !inMemory, UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
          UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
          createInitialTask()
      }
  }
  
  private func createInitialTask() {
      let viewContext = container.viewContext
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
      newItem.name = "Task example"
      newItem.type = "Example"
      newItem.isDone = false
      newItem.date = Date()
      newItem.time = Date()
      newItem.assigned = "Me"
      newItem.details = "Task details"

      do {
          try viewContext.save()
      } catch {
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
  }
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
    
}
