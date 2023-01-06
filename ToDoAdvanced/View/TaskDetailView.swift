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
    
    @State var name: String = ""
    @State var type: String = ""
    var selections = ["Chores", "Cleaning", "Shopping", "Cooking"]
    var colors = [1, 2, 3, 4]
    @State var selectedIndex = 0
    @State var isDone: Bool = false
    @State var date: Date = Date()
    @State private var isDated = false
    @State var time: Date = Date()
    @State private var isTimed = false
    @State var assigned: String = ""
    var assignedPeople = ["Me", "Harry", "Herminone", "Ron"]
    @State var details: String = ""
  
    var body: some View {
            Form {
                Section(header: Text("Name")) {
                    TextField("Title", text: $name)
                }
//                Section(header: Text("Type")) {
//                    CustomSegmentedView($selectedIndex, selections: selections)
//                    Text("\(selections[selectedIndex])")
//                }
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
                        Text("Date")
                    }
                    if isDated == true {
                        DatePicker("Choose the date", selection: $date, displayedComponents: .date)
                            .onChange(of: date) {
                                print($0)
                            }
                            .datePickerStyle(.graphical)
                    }
                    Toggle(isOn: $isTimed) {
                        Text("Time")
                    }
                    if isTimed == true {
                        DatePicker("Choose the time", selection: $time, displayedComponents: .hourAndMinute)
                            .onChange(of: time) {
                                print($0)
                            }
                            .datePickerStyle(.graphical)
                    }
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
                ToolbarItem {
                    ShareLink(item: "Task: \(name)", /*subject: Text("\(assigned)")*/ message: Text("\(details)")) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editItem()
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
                        let comps = Calendar.current.dateComponents([.hour, .minute], from: time)
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
                        
                        print(comps)
                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                    } label: {
                        Text("Edit")
                            .fontWeight(.bold)
                    }
                    .disabled(self.name.isEmpty)
                }
            }
            
//        }
    }
    private func editItem() {
        withAnimation {
            item.name = name
            item.type = selections.joined()
            item.isDone = isDone
            item.date = date
            item.time = time
            item.assigned = assigned
            item.details = details
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//            newItem.name = name
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
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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
        item.assigned = "ME"
        item.details = "Fooood"
        return item
    }()
    
    static var previews: some View {
        TaskDetailView(item: item)
            .environment(\.managedObjectContext, persistence.container.viewContext)
//            .environmentObject(Favorites())
    }
}
//
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
