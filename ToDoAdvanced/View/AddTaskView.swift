//
//  AddTaskView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

//import SwiftUI
//import CoreData
//import UserNotifications
//
//enum TaskTypes: String, Identifiable, CaseIterable {
//    
//    var id: UUID {
//        return UUID()
//    }
//    
//    case red = "Chores"
//    case green = "Cleaning"
//    case blue = "Shopping"
//    case yellow = "Cooking"
//}
//
//extension TaskTypes {
//
//    var title: String {
//        switch self {
//        case .red:
//            return "Chores"
//        case .green:
//            return "Cleaning"
//        case .blue:
//            return "Shopping"
//        case .yellow:
//            return "Cooking"
//        }
//    }
//}
//
//struct AddTaskView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.dismiss) var dismiss
//    
//    let notificationManager = NotificationManager()
//    @State var name: String
//    @State var priority: String
//    @State var type: String
//    var selections =  ["Chores", "Cleaning", "Shopping", "Cooking"]
////    TaskTypes(rawValue: "Chores")
//    @State var isDone: Bool
//    //    @State var date: Date = Date.now
//    @State private var isDated = false
//    //    var selectedDate = Date()
//    @State var time: Date = Date.now
//    @State private var isTimed = false
//    @State var assigned: String
//    var assignedPeople = ["Me", "Harry", "Herminone", "Ron"]
//    @State var details: String
//    @State private var selectedColor: Color = .gray
//    
//    @State var date: Date
//    //    let dateRange: ClosedRange<Date> = {
//    //        let calendar = Calendar.current
//    //        let startComponents = DateComponents(year: 2023, month: 1, day: 1)
//    //        let endComponents = DateComponents(year: 2200, month: 12, day: 31, hour: 23, minute: 59, second: 59)
//    //        return calendar.date(from:startComponents)!
//    //            ...
//    //            calendar.date(from:endComponents)!
//    //    }()
//    
//
//
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Name")) {
//                    TextField("Title", text: $name)
//                }
////                Section(header: Text("Type")) {
////                    Picker("Types", selection: $type) {
////                        ForEach(selections, id: \.self) {
////                            Text($0)
////                        }
////                    }
////                    .pickerStyle(.segmented)
//////                    .colorMultiply(.red)
////
////                }
//                Section(header: Text("Priority")) {
//                    VStack {
//                        ColorPickerView(selectedColor: $selectedColor)
//                            .font(.system(size: 32))
//                    }.frame(maxWidth: .infinity, maxHeight: 200)
////                        .background(Color(red: 1.0, green: 1.0, blue: 1.0))
//                        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
//                    
//                }
//                Section(header: Text("Status")) {
//                    Toggle(isOn: $isDone) {
//                        Text("Finished")
//                    }
//                }
//                Section(header: Text("Reminder")) {
//                    Toggle(isOn: $isDated) {
//                        Text("\(date.formatted(.dateTime.day().month(.wide).year()))")
//                        Text(date, style: .time)
//                    }
//                    if isDated == true {
//                        DatePicker("Choose the date", selection: $date, displayedComponents: [.date, .hourAndMinute])
//                            .onChange(of: date) {
//                                print($0)
//                            }
//                            .datePickerStyle(.graphical)
//                    }
//                    
//                    
//                    //                    Toggle(isOn: $isTimed) {
//                    //                        Text("Time")
//                    //                    }
//                    //                    if isTimed == true {
//                    //                        DatePicker("Choose the time", selection: $time, displayedComponents: .hourAndMinute)
//                    //                            .onChange(of: time) {
//                    //                                print($0)
//                    //                            }
//                    //                            .datePickerStyle(.graphical)
//                    //                    }
//                }
////                Section(header: Text("Who's in charge?")) {
////                    Picker("People", selection: $assigned) {
////                        ForEach(assignedPeople, id: \.self) {
////                            Text($0)
////                        }
////                    }
////                }
////                .pickerStyle(.automatic)
//                Section(header: Text("Details")) {
//                    TextEditor(text: $details)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        addItem()
//                        dismiss()
//                        scheduleNotification()
//                        
//                    } label: {
//                        Text("Add")
//                    }
//                    .disabled(self.name.isEmpty)
//                }
//            }
//        }
//    }
//    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//            newItem.name = name
//            newItem.priority = priority
//            //            newItem.type = selections.joined()
//            newItem.type = type
//            newItem.isDone = isDone
//            newItem.date = date
//            newItem.time = time
//            newItem.assigned = assigned
//            newItem.details = details
//            
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//    
//    private func scheduleNotification() {
//        let notificationId = UUID()
//        let content = UNMutableNotificationContent()
//        content.body = "Reminder: \(name)"
//        content.sound = UNNotificationSound.default
//        content.userInfo = [
//            "notificationId": "\(notificationId)" // additional info to parse if need
//        ]
//        
//        let trigger = UNCalendarNotificationTrigger(
//            dateMatching: NotificationHelper.getTriggerDate(triggerDate: date)!,
//            repeats: false
//        )
//        
//        notificationManager.scheduleNotification(
//            id: "\(notificationId)",
//            content: content,
//            trigger: trigger)
//    }
//    
//    
//}
//
//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView(name: "", priority: "", type: "", isDone: false, time: Date(), assigned: "", details: "", date: .now)
//    }
//}


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
    @State var assigned: String = ""
    var assignedPeople = ["Me", "Harry", "Hermione", "Ron"]
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
                    Picker("Assign to", selection: $assigned) {
                        ForEach(assignedPeople, id: \.self) {
                            Text($0)
                        }
                    }
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
            newItem.assigned = assigned
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
