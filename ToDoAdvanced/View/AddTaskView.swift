//
//  AddTaskView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import SwiftUI
import CoreData
import UserNotifications

enum TaskTypes: String, Identifiable, CaseIterable {
  var id: UUID {
    return UUID()
  }
  
  case red = "Chores"
  case green = "Cleaning"
  case blue = "Shopping"
  case yellow = "Cooking"
}

extension TaskTypes {
  var title: String {
    switch self {
    case .red:
      return "Chores"
    case .green:
      return "Cleaning"
    case .blue:
      return "Shopping"
    case .yellow:
      return "Cooking"
    }
  }
}

struct AddTaskView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) var dismiss
  
  let notificationManager = NotificationManager()
  @State var name: String = ""
  @State var priority: String = ""
  @State var type: String = ""
  var selections = ["Chores", "Cleaning", "Shopping", "Cooking"]
  @State var isDone: Bool = false
  @State private var isDated = false
  @State var time: Date = Date.now
  @State private var isTimed = false
  @State var assigned: String = "" // Changed from array to String
  @State var details: String = ""
  @State private var selectedColor: Color = .gray
  @State var date: Date = Date.now
  @State private var showAlert = false
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Name*")) {
          TextField("Title", text: $name)
        }
        Section(header: Text("Type*")) {
          Picker("Type", selection: $type) {
            ForEach(selections, id: \.self) {
              Text($0)
            }
          }
        }
        Section(header: Text("Date and Time")) {
          DatePicker("Select Date", selection: $date, displayedComponents: .date)
          DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
        }
        Section(header: Text("Assigned to")) {
          TextField("Assign to", text: $assigned)
        }
        Section(header: Text("Details")) {
          TextEditor(text: $details)
        }
        Section {
          Button("Save") {
            if name.isEmpty || type.isEmpty {
              showAlert = true
            } else {
              addItem()
              dismiss()
            }
          }
          .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation Error"), message: Text("Please fill the required fields with a star"), dismissButton: .default(Text("OK")))
          }
        }
      }
      .navigationTitle("Add Task")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: Button("Cancel") {
        dismiss()
      })
    }
  }
  
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
      newItem.name = name
      newItem.priority = priority
      newItem.type = type
      newItem.isDone = isDone
      newItem.date = date
      newItem.time = time
      newItem.assigned = assigned // Assigned as a string
      newItem.details = details
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  private func scheduleNotification() {
    let notificationId = UUID()
    let content = UNMutableNotificationContent()
    content.body = "Reminder: \(name)"
    content.sound = UNNotificationSound.default
    content.userInfo = [
      "notificationId": "\(notificationId)"
    ]
    
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: NotificationHelper.getTriggerDate(triggerDate: date)!,
      repeats: false
    )
    
    notificationManager.scheduleNotification(
      id: "\(notificationId)",
      content: content,
      trigger: trigger)
  }
}

struct AddTaskView_Previews: PreviewProvider {
  static var previews: some View {
    AddTaskView()
  }
}
