//
//  TaskViewModel.swift
//  NC2
//
//  Created by Evelin Evelin on 27/07/22.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @StateObject var quadrant: DataQuadrant = DataQuadrant()
    
    @Published var dataTask: [DataTask] = [DataTask]()
    @Published var showingAlert = false
    
    @Published var taskName: String = ""
    @Published var taskNote: String = ""
    @Published var deadlineDate = Date()
    @Published var quadrantSelected: DataQuadrant = DataQuadrant()

    
    func getTaskByQuadrant(){
        dataTask = quadrant.dataTasks
    }
        
    func saveEditedTask(task: DataTask){
        CoreDataManager.shared.saveEditedTask(task: task, quadrantSelected: quadrantSelected)
    }
    
    func resetInput(){
        taskName = ""
        taskNote = ""
        deadlineDate = Date.now
    }
    
    func addTask(){
        let newTask = DataTask(context: CoreDataManager.shared.viewContext)
        newTask.dataID = UUID()
        newTask.name = taskName
        newTask.note = taskNote
        newTask.deadline = deadlineDate
        newTask.ofQuadrant = quadrantSelected
        
        CoreDataManager.shared.saveContext()
        
        NotifManager.shared.dataID = newTask.dataID!.uuidString
        NotifManager.shared.content.title = "Reminder"
        NotifManager.shared.content.subtitle = newTask.name!
        NotifManager.shared.content.sound = UNNotificationSound.default
        NotifManager.shared.setNotifByDate(deadline: newTask.deadline!)
        
        resetInput()
    }
        
    func finishTask(task: DataTask) {
        withAnimation {
            task.isFinished = true
            CoreDataManager.shared.viewContext.delete(task)
            
            CoreDataManager.shared.saveContext()
            
        }
    }
    
    func deleteTask(at offsets: IndexSet, quadrant: DataQuadrant) {
        for index in offsets {
            NotifManager.shared.deleteNotif(dataID: quadrant.dataTasks[index].dataID!.uuidString)
            CoreDataManager.shared.viewContext.delete(quadrant.dataTasks[index])
        }
        CoreDataManager.shared.saveContext()
    }
    
    func buttonAction(task: DataTask){
        if(!task.isFinished) { showingAlert = true }
        else { task.isFinished = false }
        CoreDataManager.shared.saveContext()
    }
}
