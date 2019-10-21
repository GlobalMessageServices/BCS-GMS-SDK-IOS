//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by ard on 11/05/2019.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var attribute: NSDecimalNumber?
    @NSManaged public var attribute1: NSDate?

}
