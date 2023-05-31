//
//  ContentView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 04/01/2023.
//

import SwiftUI
import CoreData
import UserNotifications

//enum Status: String, Identifiable, CaseIterable {
//
//    var id: UUID {
//        return UUID()
//    }
//
//    case todo = "ToDo"
//    case all = "All"
//    case done = "Done"
//}
//
//extension Status {
//
//    var title: String {
//        switch self {
//        case .todo:
//            return "Todo"
//        case .all:
//            return "All"
//        case .done:
//            return "Done"
//        }
//    }
//}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State var selectedFilter = TaskFilter.All
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    let notificationManager = NotificationManager()

    @State private var showingAddTask = false
    @State private var showingTask = false
    
    @State private var searchText = ""
    @State private var selectedIndex = 0
    @State var selected = 2
    //    @Binding var isDone: Bool
    
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    private enum Section: String, Identifiable, CaseIterable {
        case todo, all//, done
        var id: String { rawValue }
        
        var displayName: String { rawValue.capitalized }
    }
    
//    var searchResults: [String] {
//        if searchText.isEmpty {
//            return items
//        } else {
//            return items.filter { $0.contains(searchText) }
//        }
//    }
    
    var body: some View {
        NavigationView {
            List {
                if selected == 1 {
                    //                    Text("Todo")
//                    ForEach(searchResults, id: \.self) { item in
                    ForEach(items) { item in
                        NavigationLink {
                            TaskDetailView(item: item, name: item.name ?? "Name", type: item.type ?? "Type", isDone: item.isDone, time: item.time ?? .now, assigned: item.assigned ?? "Voldemort", details: item.details ?? "Details", date: Date())
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(item.name!)")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    Spacer()
                                    // Priority Circle color to do
//                                    Image(systemName: selectedColor == color ? Constants.Icons.recordCircleFill: Constants.Icons.circleFill)
//                                        .foregroundColor(color)
//                                        .clipShape(Circle())
//                                        .onTapGesture {
//                                            print(color)
//                                            selectedColor = color
//                                        }
                                    
                                    
                                    //                                Toggle(isOn: item.isDone!) {
                                    //                                    Text("Finished")
                                    //                                }
                                    //                                Button(favorites.contains(book) ? "Remove from Favorites" : "Add to Favorites") {
                                    //                                    if favorites.contains(book) {
                                    //                                        favorites.remove(book)
                                    //                                    } else {
                                    //                                        favorites.add(book)
                                    //                                    }
                                    //                                }
                                    //                                .buttonStyle(.borderedProminent)
                                    //                                .padding()
                                }
                                HStack {
                                    if item.assigned != nil {
                                        Text("by \(item.assigned!)")
                                    }
                                    
                                    Spacer()
                                    HStack {
                                        Text(item.date!, style: .date)
                                        Text(item.date!, style: .time)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .padding(.leading)
                                }
                                
                            }
                        }
                        //                            Button(action: {
                        //                                showingTask = true
                        //                            }) {
                        //
                        //                                VStack(alignment: .leading) {
                        //                                    HStack {
                        //                                        Text("\(item.name!)")
                        //                                            .font(.title2)
                        //                                            .fontWeight(.medium)
                        //                                        //                                Toggle(isOn: item.isDone!) {
                        //                                        //                                    Text("Finished")
                        //                                        //                                }
                        //                                        //                                Button(favorites.contains(book) ? "Remove from Favorites" : "Add to Favorites") {
                        //                                        //                                    if favorites.contains(book) {
                        //                                        //                                        favorites.remove(book)
                        //                                        //                                    } else {
                        //                                        //                                        favorites.add(book)
                        //                                        //                                    }
                        //                                        //                                }
                        //                                        //                                .buttonStyle(.borderedProminent)
                        //                                        //                                .padding()
                        //                                    }
                        //                                    HStack {
                        //                                        Text("to \(item.assigned!)")
                        //
                        //                                        Text("\(item.date!)")
                        //                                            .font(.subheadline)
                        //                                            .fontWeight(.light)
                        //                                            .padding(.leading)
                        //                                    }
                        //
                        //                                }
                        //                            }
                        //                            //                    .background(Color.gray)
                        //                            .cornerRadius(20)
                        //                            .sheet(isPresented: $showingTask) {
                        //                                TaskDetailView(item: item, name: item.name ?? "Name", type: item.type ?? "Type", isDone: item.isDone, date: item.date ?? .now, time: item.time ?? .now, assigned: item.assigned ?? "Voldemort", details: item.details ?? "Details")
                        //                            }
                        //                            .buttonStyle(.bordered)
                    }
//                }
                    .onDelete(perform: deleteItems)
                    //                .onDelete(perform: DeleteModifier(action: () -> Void))
                } else if selected == 2 {
                    ForEach(items) { item in
                        NavigationLink {
                            TaskDetailView(item: item, name: item.name ?? "Name", type: item.type ?? "Type", isDone: item.isDone, time: item.time ?? .now, assigned: item.assigned ?? "Voldemort", details: item.details ?? "Details", date: Date())
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(item.name!)")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    //                                Toggle(isOn: item.isDone!) {
                                    //                                    Text("Finished")
                                    //                                }
                                    //                                Button(favorites.contains(book) ? "Remove from Favorites" : "Add to Favorites") {
                                    //                                    if favorites.contains(book) {
                                    //                                        favorites.remove(book)
                                    //                                    } else {
                                    //                                        favorites.add(book)
                                    //                                    }
                                    //                                }
                                    //                                .buttonStyle(.borderedProminent)
                                    //                                .padding()
                                }
                                HStack {
                                    if item.assigned != nil {
                                        Text("by \(item.assigned!)")
                                    }
                                   
                                    Spacer()
                                    HStack {
                                        Text(item.date!, style: .date)
                                        Text(item.date!, style: .time)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .padding(.leading)
                                }
                                
                            }
                        }
                     
                    }
                    .onDelete(perform: deleteItems)
                    //                .onDelete(perform: DeleteModifier(action: () -> Void))
                } else {
//                    Text("Done")
                    ForEach(items) { item in
                        NavigationLink {
                            TaskDetailView(item: item, name: item.name ?? "Name", type: item.type ?? "Type", isDone: item.isDone, time: item.time ?? .now, assigned: item.assigned ?? "Voldemort", details: item.details ?? "Details", date: Date())
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(item.name!)")
                                        .font(.title2)
                                        .fontWeight(.medium)
                                    //                                Toggle(isOn: item.isDone!) {
                                    //                                    Text("Finished")
                                    //                                }
                                    //                                Button(favorites.contains(book) ? "Remove from Favorites" : "Add to Favorites") {
                                    //                                    if favorites.contains(book) {
                                    //                                        favorites.remove(book)
                                    //                                    } else {
                                    //                                        favorites.add(book)
                                    //                                    }
                                    //                                }
                                    //                                .buttonStyle(.borderedProminent)
                                    //                                .padding()
                                }
                                HStack {
                                    if item.assigned != nil {
                                        Text("by \(item.assigned!)")
                                    }
                                   
                                    Spacer()
                                    HStack {
                                        Text(item.date!, style: .date)
                                        Text(item.date!, style: .time)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .padding(.leading)
                                }
                                
                            }
                        }
                    
                    }
                    .onDelete(perform: deleteItems)
                    //                .onDelete(perform: DeleteModifier(action: () -> Void))
                }
                
            }
            //                LazyVStack(spacing: 20) {
            //                    if selected == 1 {
            //                        Text("Todo")
            //                    } else if selected == 2 {
            //                        ForEach(items) { item in
            //                            Button(action: {
            //                                showingTask = true
            //                            }) {
            //
            //                                VStack(alignment: .leading) {
            //                                    HStack {
            //                                        Text("\(item.name!)")
            //                                            .font(.title2)
            //                                            .fontWeight(.medium)
            //                                        //                                Toggle(isOn: item.isDone!) {
            //                                        //                                    Text("Finished")
            //                                        //                                }
            //                                        //                                Button(favorites.contains(book) ? "Remove from Favorites" : "Add to Favorites") {
            //                                        //                                    if favorites.contains(book) {
            //                                        //                                        favorites.remove(book)
            //                                        //                                    } else {
            //                                        //                                        favorites.add(book)
            //                                        //                                    }
            //                                        //                                }
            //                                        //                                .buttonStyle(.borderedProminent)
            //                                        //                                .padding()
            //                                    }
            //                                    HStack {
            //                                        Text("to \(item.assigned!)")
            //
            //                                        Text("\(item.date!)")
            //                                            .font(.subheadline)
            //                                            .fontWeight(.light)
            //                                            .padding(.leading)
            //                                    }
            //
            //                                }
            //                            }
            //                            //                    .background(Color.gray)
            //                            .cornerRadius(20)
            //                            .sheet(isPresented: $showingTask) {
            //                                TaskDetailView(item: item, name: item.name ?? "Name", type: item.type ?? "Type", isDone: item.isDone, date: item.date ?? .now, time: item.time ?? .now, assigned: item.assigned ?? "Voldemort", details: item.details ?? "Details")
            //                            }
            //                            .buttonStyle(.bordered)
            //                        }
            //                        .onDelete(perform: deleteItems)
            //                        //                .onDelete(perform: DeleteModifier(action: <#() -> Void#>))
            //                        Spacer()
            //                    } else {
            //                        Text("Done")
            //                    }
            //
            //                }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                    //                            .hidden()
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Picker(selection: $selected, label: Text("Picker"), content: {
                            Text("ToDo").tag(1)
                            Text("All").tag(2)
                            Text("Done").tag(3)
                        })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(name: "", priority: "", type: "", isDone: false, time: Date(), assigned: "", details: "", date: .now)
            }
            .navigationBarTitle(Text("Tasks"), displayMode: .inline)
        }
        .searchable(text: $searchText)
    }

    private func filteredItems() -> [Item] {
        if selectedFilter == TaskFilter.Done {
            return taskViewModel.items.filter {$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.All {
            return taskViewModel.items.filter {$0.isCompleted() && !$0.isCompleted()}
        }
        
        if selectedFilter == TaskFilter.ToDo {
            return taskViewModel.items.filter {!$0.isCompleted()}
        }
        
        return taskViewModel.items
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
    
    //    private func styleForPriority(_ value: String) -> Color {
    //        let priority = Status(rawValue: value)
    //
    //        switch priority {
    //            case .todo:
    //                return Color.green
    //            case .all:
    //                return Color.orange
    //            case .done:
    //                return Color.red
    //            default:
    //                return Color.black
    //        }
    //    }
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


struct DeleteModifier: ViewModifier {
    
    let action: () -> Void
    
    @State var offset: CGSize = .zero
    @State var initialOffset: CGSize = .zero
    @State var contentWidth: CGFloat = 0.0
    @State var willDeleteIfReleased = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                            .layoutPriority(-1)
                    }.frame(width: -offset.width)
                        .offset(x: geometry.size.width)
                        .onAppear {
                            contentWidth = geometry.size.width
                        }
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    delete()
                                }
                        )
                }
            )
            .offset(x: offset.width, y: 0)
            .gesture (
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width + initialOffset.width <= 0 {
                            self.offset.width = gesture.translation.width + initialOffset.width
                        }
                        if self.offset.width < -deletionDistance && !willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        } else if offset.width > -deletionDistance && willDeleteIfReleased {
                            hapticFeedback()
                            willDeleteIfReleased.toggle()
                        }
                    }
                    .onEnded { _ in
                        if offset.width < -deletionDistance {
                            delete()
                        } else if offset.width < -halfDeletionDistance {
                            offset.width = -tappableDeletionWidth
                            initialOffset.width = -tappableDeletionWidth
                        } else {
                            offset = .zero
                            initialOffset = .zero
                        }
                    }
            )
            .animation(.interactiveSpring())
    }
    
    private func delete() {
        offset.width = -contentWidth
        action()
    }
    
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    //MARK: Constants
    
    let deletionDistance = CGFloat(200)
    let halfDeletionDistance = CGFloat(50)
    let tappableDeletionWidth = CGFloat(100)
    
    
}

extension View {
    
    func onDelete(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeleteModifier(action: action))
    }
    
    func deleteRow(action: @escaping () -> Void) -> some View {
        modifier(DeleteModifier(action: action))
    }
    
    
}
