//
//  DataTimer+CoreDataProperties.swift
//  NC2
//
//  Created by Evelin Evelin on 27/07/22.
//
//

import Foundation
import CoreData


extension DataTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataTimer> {
        return NSFetchRequest<DataTimer>(entityName: "DataTimer")
    }

    @NSManaged public var dateTimer: String?
    @NSManaged public var minute: Double

}

extension DataTimer : Identifiable {

}
