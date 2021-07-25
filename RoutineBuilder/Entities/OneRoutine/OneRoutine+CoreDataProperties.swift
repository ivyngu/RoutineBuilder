//
//  OneRoutine+CoreDataProperties.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/25/21.
//
//

import Foundation
import CoreData


extension OneRoutine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OneRoutine> {
        return NSFetchRequest<OneRoutine>(entityName: "OneRoutine")
    }

    @NSManaged public var name: String?
    @NSManaged public var index: Int16
    @NSManaged public var hasRoutineItems: NSSet?

}

// MARK: Generated accessors for hasRoutineItems
extension OneRoutine {

    @objc(addHasRoutineItemsObject:)
    @NSManaged public func addToHasRoutineItems(_ value: RoutineItem)

    @objc(removeHasRoutineItemsObject:)
    @NSManaged public func removeFromHasRoutineItems(_ value: RoutineItem)

    @objc(addHasRoutineItems:)
    @NSManaged public func addToHasRoutineItems(_ values: NSSet)

    @objc(removeHasRoutineItems:)
    @NSManaged public func removeFromHasRoutineItems(_ values: NSSet)

}

extension OneRoutine : Identifiable {

}
