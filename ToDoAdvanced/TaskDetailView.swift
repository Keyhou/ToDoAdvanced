//
//  TaskDetailView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import SwiftUI
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
//        VStack {
//            Text("\(item.name ?? "Get food")")
//
//            Text(item.type ?? "ToDo")
////            Text(item.isDone)
//
//            Text(item.assigned ?? "Christ")
//        }
//        .navigationBarTitle(item.name ?? "TaskName")
//        .navigationBarTitleDisplayMode(.inline)
        NavigationStack {
            VStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Title", text: $name)
                }
                Section(header: Text("Type")) {
                    //                    Picker("Types", selection: $type) {
                    //                        ForEach(selections.indices, id: \.self) { index in
                    //                            Text(selections[index])
                    //                        }
                    //                    }
                    //                    .pickerStyle(.segmented)
                    //                    .colorMultiply(.red)
                    ////                    .colorMultiply(
                    ////                        if types[typeIndex] == 0 {
                    ////                            .red
                    ////                        } else {
                    ////                            .blue
                    ////                        }
                    ////                    )
                    CustomSegmentedView($selectedIndex, selections: selections)
                    Text("\(selections[selectedIndex])")
                }
                Section(header: Text("Status")) {
                    Toggle(isOn: $isDone) {
                        Text("Finished")
                    }
                }
                Section(header: Text("Date & Time")) {
                    Toggle(isOn: $isDated) {
                        Text("Date")
                    }
                    Toggle(isOn: $isTimed) {
                        Text("Time")
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
            //            .scrollContentBackground(.hidden)
            //            .background(.indigo)
                Button {
                    dismiss()
                    //                            .deleteItems(at: items[$0])
//                    deleteItems(offsets: IndexSet(integer: 0))
                    deleteItems(offsets: IndexSet([0]))
                } label: {
                    Text("Delete")
                        .foregroundColor(Color.red)
                }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
//                            .deleteItems(at: items[$0])
                    } label: {
                        Text("Delete")
                            .foregroundColor(Color.red)
                    }
                    
                }
                
                ToolbarItem {
                    ShareLink(item: "\(name)", subject: Text("Here's your task")) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editItem()
                        dismiss()
                        let content = UNMutableNotificationContent()
                        content.title = "Feed the cat"
                        content.subtitle = "It looks hungry"
                        content.sound = UNNotificationSound.default

                        // show this notification five seconds from now
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                    } label: {
                        Text("Edit")
                            .fontWeight(.bold)
                    }
                    .disabled(self.name.isEmpty)
                }
            }
            
        }
    }
    private func editItem() {
        withAnimation {
            item.name = name
            item.type = type
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
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.blue.opacity(0.3))
        UISegmentedControl.appearance().backgroundColor =
        UIColor(Color.orange.opacity(0.3))
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
