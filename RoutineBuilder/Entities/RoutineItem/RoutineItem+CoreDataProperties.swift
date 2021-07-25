//
//  RoutineItem+CoreDataProperties.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/19/21.
//
//

import Foundation
import CoreData


extension RoutineItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineItem> {
        return NSFetchRequest<RoutineItem>(entityName: "RoutineItem")
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var durationMinutes: Int16
    @NSManaged public var durationSeconds: Int16
    @NSManaged public var belongsToRoutine: OneRoutine?

}

extension RoutineItem : Identifiable {

}
