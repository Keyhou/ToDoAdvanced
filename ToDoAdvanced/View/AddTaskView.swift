//
//  AddTaskView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import SwiftUI
import CoreData
import UserNotifications

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State var name: String
    @State var type: String
    @State var selections = ["Chores", "Cleaning", "Shopping", "Cooking"]
    @State var isDone: Bool
//    @State var date: Date = Date.now
    @State private var isDated = false
    var selectedDate = Date()
    @State var time: Date = Date.now
    @State private var isTimed = false
    @State var assigned: String
    var assignedPeople = ["Me", "Harry", "Herminone", "Ron"]
    @State var details: String
    
    @State private var date = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2023, month: 1, day: 1)
        let endComponents = DateComponents(year: 2200, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Title", text: $name)
                }
                Section(header: Text("Type")) {
                    Picker("Types", selection: $type) {
                        ForEach(selections, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.red)
                }
                Section(header: Text("Status")) {
                    Toggle(isOn: $isDone) {
                        Text("Finished")
                    }
                }
                Section(header: Text("Reminder")) {
                    Toggle(isOn: $isDated) {
                        Text("\(date.formatted(.dateTime.day().month(.wide).year()))")
                        Text(date, style: .time)
                    }
                    if isDated == true {
                        DatePicker("Choose the date", selection: $date, in: dateRange, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: date) {
                                print($0)
                            }
                            .datePickerStyle(.graphical)
                    }
                    
                    
//                    Toggle(isOn: $isTimed) {
//                        Text("Time")
//                    }
//                    if isTimed == true {
//                        DatePicker("Choose the time", selection: $time, displayedComponents: .hourAndMinute)
//                            .onChange(of: time) {
//                                print($0)
//                            }
//                            .datePickerStyle(.graphical)
//                    }
                }
                Section(header: Text("Who's in charge?")) {
                    Picker("People", selection: $assigned) {
                        ForEach(assignedPeople, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .pickerStyle(.automatic)
                Section(header: Text("Details")) {
                    TextEditor(text: $details)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addItem()
                        dismiss()
                        
                        // AUTO NOTIFICATIONS
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        let content = UNMutableNotificationContent()
                        content.title = name
                        content.subtitle = details
                        content.sound = UNNotificationSound.default
                        
                        // show this notification five seconds from now
                        //   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let comps = Calendar.current.dateComponents([.hour, .minute], from: time)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
                        
                        print(comps)
                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                        // SCHEDULED NOTIFICATIONS
                        //                        var dateComponents = DateComponents()
                        //                        dateComponents.calendar = Calendar.current
                        //                        let content = UNMutableNotificationContent()
                        //                        content.title = name
                        //                        content.subtitle = details
                        //                        content.sound = UNNotificationSound.default
                        //
                        //                        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                        //
                        ////                        dateComponents.weekday = 5
                        //                        dateComponents.hour = 13
                        //                        dateComponents.minute = 53
                        //
                        //                        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
                        //                        print(comps)
                        //
                        //                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        //                        UNUserNotificationCenter.current().add(request)
                        //                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                    } label: {
                        Text("Add")
                    }
                    .disabled(self.name.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = name
            newItem.type = selections.joined()
            newItem.isDone = isDone
            newItem.date = date
            newItem.time = time
            newItem.assigned = assigned
            newItem.details = details
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(name: "", type: "", isDone: false, time: Date(), assigned: "", details: "")
    }
}
