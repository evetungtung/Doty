//
//  EditTaskView.swift
//  NC2
//
//  Created by Evelin Evelin on 25/07/22.
//

import SwiftUI

struct EditTaskView: View {    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var task: DataTask
    @State private var quadrantSelected: DataQuadrant = DataQuadrant()
    @State private var dataQuadrant: [DataQuadrant] = [DataQuadrant]()
    
    @ObservedObject var taskVM = TaskViewModel()
    @ObservedObject var quadrantVM = QuadrantViewModel()

    @FocusState var isInputActive: Bool
    
    var body: some View {
        Form{
            Section{
                TextField("Task Name", text: $task.name.toUnwrapped(defaultValue: ""))
                
                DatePicker(selection: $task.deadline.toUnwrapped(defaultValue: Date.now)) {
                    Text("Deadline")
                }
                
                Picker("Select the quadrant", selection: $quadrantSelected){
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
                TextEditor(text: $task.note.toUnwrapped(defaultValue: ""))
                    .disableAutocorrection(true)
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
                quadrantSelected = task.ofQuadrant!
                dataQuadrant = CoreDataManager.shared.getAllQuadrant()
            }
        }
        .navigationBarItems(
            trailing:
                Button("Save",
                       action: {
                           CoreDataManager.shared.saveEditedTask(task: task, quadrantSelected: quadrantSelected)
                           self.presentationMode.wrappedValue.dismiss()
                           
                       })
                .foregroundColor(Color.newPink)
            
        )
        .navigationTitle("Edit Task")
    }
}

//struct EditTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTaskView()
//    }
//}
