////
////  SplitView.swift
////  ToDoAdvanced
////
////  Created by Keyhan Mortezaeifar on 14/07/2024.
////
//
//import SwiftUI
//import CoreData
//
//struct SplitView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @State private var selectedFilter: TaskFilter = .ToDo
//    @State private var showingAddTask = false
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var filteredItems: [Item] {
//        switch selectedFilter {
//        case .ToDo:
//            return items.filter { !$0.isDone }
//        case .All:
//            return Array(items)
//        case .Done:
//            return items.filter { $0.isDone }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            List {
//                Picker("Filter", selection: $selectedFilter) {
//                    ForEach(TaskFilter.allCases, id: \.self) { filter in
//                        Text(filter.rawValue).tag(filter)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//
//                ForEach(filteredItems) { item in
//                    NavigationLink(destination: TaskDetailView(item: item)) {
//                        VStack(alignment: .leading) {
//                            Text(item.name ?? "No Name")
//                                .font(.headline)
//                            Text(item.details ?? "No Details")
//                                .font(.subheadline)
//                            if let timestamp = item.timestamp {
//                                Text("Date: \(timestamp, formatter: itemFormatter)")
//                            }
//                            if let time = item.time {
//                                Text("Time: \(time, formatter: timeFormatter)")
//                            }
//                        }
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .navigationTitle("Task List")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { showingAddTask.toggle() }) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            .sheet(isPresented: $showingAddTask) {
//                AddTaskView().environment(\.managedObjectContext, viewContext)
//            }
//        }
//        .navigationViewStyle(DoubleColumnNavigationViewStyle())
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    return formatter
//}()
//
//private let timeFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.timeStyle = .short
//    return formatter
//}()
//
//struct SplitView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Creating a mock context for the preview
//        let context = PersistenceController.preview.container.viewContext
//
//        // Creating some sample items
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        let items = try! context.fetch(fetchRequest)
//
//        return SplitView().environment(\.managedObjectContext, context)
//    }
//}
//
//#Preview {
//  SplitView()
//}
