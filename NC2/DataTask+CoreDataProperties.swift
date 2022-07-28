//
//  DataTask+CoreDataProperties.swift
//  NC2
//
//  Created by Evelin Evelin on 27/07/22.
//
//

import Foundation
import CoreData


extension DataTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataTask> {
        return NSFetchRequest<DataTask>(entityName: "DataTask")
    }

    @NSManaged public var dataID: UUID?
    @NSManaged public var deadline: Date?
    @NSManaged public var isFinished: Bool
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var ofQuadrant: DataQuadrant?

}

extension DataTask : Identifiable {

}
