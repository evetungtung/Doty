//
//  AddTask.swift
//  NC2
//
//  Created by Evelin Evelin on 19/07/22.
//

import SwiftUI
import UserNotifications


struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var placeholderForTextEditor: String = "Notes"
    @State private var dataQuadrant: [DataQuadrant] = [DataQuadrant]()
    
    @ObservedObject var taskVM = TaskViewModel()
    @ObservedObject var quadrantVM = QuadrantViewModel()

    @FocusState var isInputActive: Bool
    
    
    var body: some View {
        Form{
            Section{
                TextField("Input task name...", text: $taskVM.taskName)
                    .disableAutocorrection(true)
                
                DatePicker(selection: $taskVM.deadlineDate) {
                    Text("Deadline")
                }
                
                Picker("Select the quadrant", selection: $taskVM.quadrantSelected){
                    ForEach(dataQuadrant.sorted(by: { data1, data2 in
                        data1.priority > data2.priority
                    }), id:\.self){
                        data in
                        Text(data.name ?? "Unknown name")
                    }
                }
                .pickerStyle(.menu)
            }
            Section{
                ZStack(alignment: .leading) {
                    if taskVM.taskNote.isEmpty {
                        Text(placeholderForTextEditor)
                            .foregroundColor(Color.primary.opacity(0.25))
                    }
                    TextEditor(text: $taskVM.taskNote)
                        .disableAutocorrection(true)
                }
                .onAppear(){
                    UITextView.appearance().backgroundColor = .clear
                }
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done"){
                            isInputActive = false
                        }
                        .foregroundColor(Color.blue)
                    }
                }
            } header: {
                Text("You can write your notes here")
            }
            .onAppear {
                dataQuadrant = CoreDataManager.shared.getAllQuadrant()
                taskVM.quadrantSelected = dataQuadrant[3]

//                quadrantVM.getAllQuadrant()
            }
        }.navigationBarItems(
            trailing: Button("Add",
                             action: {
                                 taskVM.addTask()
                                 self.presentationMode.wrappedValue.dismiss()
                             })
            .foregroundColor(Color.newPink)
            
        )
        .navigationTitle("Add Task")
    }
}

//
//    struct AddTask_Preview: PreviewProvider {
//        static var previews: some View {
//            AddTaskView(isPresented: false, quadrant: DataQuadrant)
//        }
//    }
