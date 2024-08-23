//
//  TaskDetailView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import SwiftUI
import CoreData
import UserNotifications

struct TaskDetailView: View {
  var item: Item
  
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) var dismiss
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  
  let notificationManager = NotificationManager()
  @State var name: String = ""
  @State var type: String = ""
  var selections = ["Chores", "Cleaning", "Shopping", "Cooking"]
  var colors = [1, 2, 3, 4]
  @State var selectedIndex = 0
  @State var isDone: Bool = false
  @State private var isDated = false
  @State var time: Date = Date()
  @State private var isTimed = false
  @State var assigned: String = ""  // Empty string instead of array of people
  @State var details: String = ""
  @State private var selectedColor: Color = .gray
  
  @State var date: Date
  
  init(item: Item) {
    self.item = item
    self._name = State(initialValue: item.name ?? "")
    self._type = State(initialValue: item.type ?? "")
    self._selectedIndex = State(initialValue: item.type == "Chores" ? 0 : item.type == "Cleaning" ? 1 : item.type == "Shopping" ? 2 : 3)
    self._isDone = State(initialValue: item.isDone)
    self._time = State(initialValue: item.time ?? Date())
    self._date = State(initialValue: item.timestamp ?? Date())
    self._assigned = State(initialValue: item.assigned ?? "") // Initialize assigned as empty string
    self._details = State(initialValue: item.details ?? "")
  }
  
  var body: some View {
    Form {
      Section(header: Text("Name")) {
        TextField("Title", text: $name)
      }
      Section(header: Text("Type")) {
        CustomSegmentedView($selectedIndex, selections: selections)
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
        Toggle(isOn: $isDone) {
          Text("Done")
        }
      }
      Section {
        Button("Edit") {
          saveTask()
          dismiss()
        }
      }
    }
    .navigationTitle("Task Details")
    .navigationBarItems(trailing: Button("Cancel") {
      dismiss()
    })
  }
  
  private func saveTask() {
    item.name = name
    item.type = selections[selectedIndex]
    item.timestamp = mergeDateAndTime(date: date, time: time)
    item.time = time
    item.isDone = isDone
    item.assigned = assigned  // Save the assigned person as a string
    item.details = details
    
    do {
      try viewContext.save()
    } catch {
      // Handle the error appropriately in a real app
      print("Failed to save task: \(error.localizedDescription)")
    }
  }
  
  private func mergeDateAndTime(date: Date, time: Date) -> Date {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
    
    var mergedComponents = DateComponents()
    mergedComponents.year = dateComponents.year
    mergedComponents.month = dateComponents.month
    mergedComponents.day = dateComponents.day
    mergedComponents.hour = timeComponents.hour
    mergedComponents.minute = timeComponents.minute
    mergedComponents.second = timeComponents.second
    
    return calendar.date(from: mergedComponents) ?? Date()
  }
}

struct TaskDetailView_Previews: PreviewProvider {
  static let persistence = PersistenceController.preview
  static var item: Item = {
    let context = persistence.container.viewContext
    let item = Item(context: context)
    item.name = "Shop"
    item.type = "Errand"
    item.isDone = false
    item.date = Date()
    item.time = Date()
    item.assigned = "Me"  // Example assignment
    item.details = "Fooood"
    return item
  }()
  
  static var previews: some View {
    TaskDetailView(item: item)
      .environment(\.managedObjectContext, persistence.container.viewContext)
  }
}

//struct CustomSegmentedView: View {
//
//    @Binding var typeIndex: Int
//    var types: [String]
//
//    init(_ typeIndex: Binding<Int>, selections: [String]) {
//        self._typeIndex = typeIndex
//        self.types = selections
//    }
//
//    var body: some View {
//        VStack {
//            Picker("", selection: $typeIndex) {
//                ForEach(types.indices, id: \.self) { index in
//                    Text(types[index])
//                        .tag(index)
//                        .foregroundColor(Color.blue)
//                }
//            }
//            .pickerStyle(.segmented)
//            .tint(.orange)
//        }
//        .padding()
//    }
//}

struct CustomSegmentedView: View {
    
    @Binding var currentIndex: Int
    var selections: [String]
    
    init(_ currentIndex: Binding<Int>, selections: [String]) {
        self._currentIndex = currentIndex
        self.selections = selections
        //        if currentIndex = 0 {
        //            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.orange.opacity(0.3))
        //        } else {
        //            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.blue.opacity(0.3))
        //        }
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.blue.opacity(0.1))
        UISegmentedControl.appearance().backgroundColor =
        UIColor(Color.white.opacity(0.3))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.primary)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.secondary)], for: .normal)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $currentIndex) {
                ForEach(selections.indices, id: \.self) { index in
                    Text(selections[index])
                        .tag(index)
                    //                        .foregroundColor(Color.blue)
                }
            }
            .pickerStyle(.segmented)
            //            .tint(.orange)
        }
    }
}

struct CustomColor {
    static let redp = Color("redp")
    static let orangep = Color("orangep")
    static let greenp = Color("greenp")
    static let bluep = Color("bluep")
}
