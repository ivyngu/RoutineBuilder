//
//  RoutineItem+CoreDataProperties.swift
//  RoutineBuilder
//
//  Created by Ivy Nguyen on 7/12/21.
//
//

import Foundation
import CoreData


extension RoutineItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineItem> {
        return NSFetchRequest<RoutineItem>(entityName: "RoutineItem")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var duration: Int16
}

extension RoutineItem : Identifiable {

}
