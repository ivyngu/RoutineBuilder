//
//  OneRoutine+CoreDataProperties.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/13/21.
//
//

import Foundation
import CoreData


extension OneRoutine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OneRoutine> {
        return NSFetchRequest<OneRoutine>(entityName: "OneRoutine")
    }

    @NSManaged public var name: String?
    @NSManaged public var routine: NSSet?

}

// MARK: Generated accessors for routine
extension OneRoutine {

    @objc(addRoutineObject:)
    @NSManaged public func addToRoutine(_ value: RoutineItem)

    @objc(removeRoutineObject:)
    @NSManaged public func removeFromRoutine(_ value: RoutineItem)

    @objc(addRoutine:)
    @NSManaged public func addToRoutine(_ values: NSSet)

    @objc(removeRoutine:)
    @NSManaged public func removeFromRoutine(_ values: NSSet)

}

extension OneRoutine : Identifiable {

}
