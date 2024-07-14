//
//  TaskListView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 14/07/2024.
//

import SwiftUI
import CoreData

struct TaskListView: View {
  @Binding var selectedFilter: TaskFilter
  var items: [Item]
  var filteredItems: [Item]
  @Binding var showingAddTask: Bool
  var viewContext: NSManagedObjectContext
  
  var body: some View {
    VStack {
      List {
        ForEach(filteredItems) { item in
          NavigationLink(destination: TaskDetailView(item: item)) {
            VStack(alignment: .leading) {
              Text(item.name ?? "No Name")
                .font(.headline)
              Text(item.details ?? "No Details")
                .font(.subheadline)
              if let timestamp = item.timestamp {
                Text("Date: \(timestamp, formatter: itemFormatter)")
              }
              if let time = item.time {
                Text("Time: \(time, formatter: timeFormatter)")
              }
            }
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddTask.toggle() }) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      .sheet(isPresented: $showingAddTask) {
        AddTaskView().environment(\.managedObjectContext, viewContext)
      }
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  return formatter
}()

private let timeFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.timeStyle = .short
  return formatter
}()

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    // Creating a mock context for the preview
    let context = PersistenceController.preview.container.viewContext
    
    // Creating some sample items
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    let items = try! context.fetch(fetchRequest)
    
    return TaskListView(
      selectedFilter: .constant(.ToDo),
      items: items,
      filteredItems: items,
      showingAddTask: .constant(false),
      viewContext: context
    )
  }
}

//#Preview {
//  TaskListView(
//    selectedFilter: .constant(.ToDo),
//    items: FetchedResults<Item>(),
//    filteredItems: [],
//    showingAddTask: .constant(false),
//    viewContext: PersistenceController.preview.container.viewContext
//  )}
