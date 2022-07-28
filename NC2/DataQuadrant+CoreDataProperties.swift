//
//  DataQuadrant+CoreDataProperties.swift
//  NC2
//
//  Created by Evelin Evelin on 27/07/22.
//
//

import Foundation
import CoreData


extension DataQuadrant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataQuadrant> {
        return NSFetchRequest<DataQuadrant>(entityName: "DataQuadrant")
    }

    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var haveTasks: NSSet?
    
    public var dataTasks: [DataTask] {
        let setTask = haveTasks as? Set<DataTask> ?? []
        
        return setTask.sorted {
            $0.name ?? "Unknown Name" > $1.name ?? "Unknown Name"
        }
    }

}

// MARK: Generated accessors for haveTasks
extension DataQuadrant {

    @objc(addHaveTasksObject:)
    @NSManaged public func addToHaveTasks(_ value: DataTask)

    @objc(removeHaveTasksObject:)
    @NSManaged public func removeFromHaveTasks(_ value: DataTask)

    @objc(addHaveTasks:)
    @NSManaged public func addToHaveTasks(_ values: NSSet)

    @objc(removeHaveTasks:)
    @NSManaged public func removeFromHaveTasks(_ values: NSSet)

}

extension DataQuadrant : Identifiable {

}
