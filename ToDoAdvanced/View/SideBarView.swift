//
//  SideBarView.swift
//  ToDoAdvanced
//
//  Created by Keyhan Mortezaeifar on 14/07/2024.
//

import SwiftUI
import CoreData

struct SidebarView: View {
    @Binding var selectedFilter: TaskFilter

    var body: some View {
        List {
            Section(header: Text("Filters")) {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TaskFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Task Filters")
    }
}

//struct SidebarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarView(selectedFilter: .constant(.ToDo))
//    }
//}

#Preview {
  SidebarView(selectedFilter: .constant(.ToDo))
}
