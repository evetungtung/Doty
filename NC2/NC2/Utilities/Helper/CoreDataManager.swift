//
//  CoreDataManager.swift
//  NC2
//
//  Created by Evelin Evelin on 22/07/22.
//

import Foundation
import CoreData
import SwiftUI


class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ModelNC2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveTimerDone(minute: Double, date: Date) {
        let timer = DataTimer(context: container.viewContext)
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        timer.minute = Double(minute)
        timer.dateTimer = dateString
        
        do {
            try container.viewContext.save()
        } catch  {
            print("Failed to save timer")
        }
    }
    
    func showDataTimer() -> [DataTimer] {
        let req: NSFetchRequest<DataTimer> = DataTimer.fetchRequest()
        do {
            return try container.viewContext.fetch(req)
        } catch  {
            return []
        }
    }
    
    func showDataToday(date: Date) -> Int {
        let date = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        let req: NSFetchRequest<DataTimer> = DataTimer.fetchRequest()
        req.predicate = NSPredicate(format: "dateTimer == %@", dateString)
        
        let records = try! container.viewContext.fetch(req)
    
        let sum = records.reduce(0) { $0 + ($1.value(forKey: "minute") as? Int ?? 0) }

        return sum
    }
    
    
    func showDataTimerToday(date: Date) -> [DataTimer] {
        let date = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        let req: NSFetchRequest<DataTimer> = DataTimer.fetchRequest()
        req.predicate = NSPredicate(format: "dateTimer == %@", dateString)
        
        do {
            return try container.viewContext.fetch(req)
        } catch  {
            return []
        }
    }
    
    func saveEditedTask(task: DataTask, quadrantSelected: DataQuadrant) {
        task.ofQuadrant = quadrantSelected
        
        CoreDataManager.shared.saveContext()
        
        NotifManager.shared.dataID = task.dataID!.uuidString
        NotifManager.shared.content.title = task.name!
        NotifManager.shared.content.subtitle = "Deadline"
        NotifManager.shared.content.sound = UNNotificationSound.default
        NotifManager.shared.setNotifByDate(deadline: task.deadline!)
    }
    
    func saveQuadrant(name: String, priority: Int16) {
        let quadrant = DataQuadrant(context: container.viewContext)
        quadrant.name = name
        quadrant.priority = priority
        
        do {
            try container.viewContext.save()
        } catch  {
        }
    }
    
    func getAllQuadrant() -> [DataQuadrant]{
        let req: NSFetchRequest<DataQuadrant> = DataQuadrant.fetchRequest()
        
        do {
            return try container.viewContext.fetch(req)
        }catch{
            return []
        }
    }
    
    func showDataTask() -> [DataTask]{
        let req: NSFetchRequest<DataTask> = DataTask.fetchRequest()
        
        do {
            return try container.viewContext.fetch(req)
        }catch{
            return []
        }
    }
    
    func quadrantInit(){
        let importantUrgent = DataQuadrant(context: viewContext)
        importantUrgent.name = "Important Urgent"
        importantUrgent.priority = 4
        
        let importantNotUrgent = DataQuadrant(context: viewContext)
        importantNotUrgent.name = "Important Not Urgent"
        importantNotUrgent.priority = 3
        
        let unimportantUrgent = DataQuadrant(context: viewContext)
        unimportantUrgent.name = "Unimportant Urgent"
        unimportantUrgent.priority = 2
        
        let unimportantNotUrgent = DataQuadrant(context: viewContext)
        unimportantNotUrgent.name = "Unimportant Not Urgent"
        unimportantNotUrgent.priority = 1
    }
}
