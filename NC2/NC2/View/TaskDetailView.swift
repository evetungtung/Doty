//
//  TaskView.swift
//  NC2
//
//  Created by Evelin Evelin on 22/07/22.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var quadrant: DataQuadrant
    
    @State private var dataTask: [DataTask] = [DataTask]()
    @State private var taskName: String = ""
    @State private var showingAlert = false
    
    @ObservedObject var taskVM = TaskViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            List {
                ForEach(dataTask, id:\.self) { task in
                    HStack(alignment: .top, spacing: 0){
                        Button {
                            taskVM.buttonAction(task: task)
                            dataTask = quadrant.dataTasks
                        } label: {
                            Image(systemName: task.isFinished ? "checkmark.circle" : "circle")
                                .frame(width: 40, height: 40, alignment: .leading)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .alert(isPresented: $taskVM.showingAlert) {
                            Alert(
                                title: Text("Finishing '\(task.name ?? "Unknown")'"),
                                message: Text("This action will delete the data and cannot be undo"),
                                primaryButton: .destructive(Text("Done"),
                                                            action: {
                                                                taskVM.finishTask(task: task)
                                                                dataTask = quadrant.dataTasks
                                                            }),
                                secondaryButton: .cancel(Text("Cancel"), action: {})
                            )
                        }
                        
                        NavigationLink { EditTaskView(task: task) } label: {
                            VStack(alignment: .leading, spacing: 5){
                                Text("\(task.name ?? "Unknown Note")").font(.headline)
                                Text("\(task.deadline?.formatted(date: .complete, time: .shortened) ?? "Unknown")").font(.system(.caption))
                            }
                        }
                    }
                    .onDrag { return NSItemProvider() }
                }
                .onMove(perform: move)
                .onDelete{
                    index in
                    taskVM.deleteTask(at: index, quadrant: quadrant)
                    dataTask = quadrant.dataTasks
                                    }
            }
        }
        .navigationBarItems(
            trailing:
                NavigationLink(destination: { AddTaskView().navigationTitle("Add Task").navigationBarTitleDisplayMode(.inline) },
                               label: { Text("Add") })
        )
        .navigationTitle( quadrant.name ?? "Unknown name" )
        .onAppear {
            dataTask = quadrant.dataTasks
            print("ONAPPEAR: \(dataTask)")
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        dataTask.move(fromOffsets: source, toOffset: destination )
    }
    
}

//
//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView().environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
//    }
//}
