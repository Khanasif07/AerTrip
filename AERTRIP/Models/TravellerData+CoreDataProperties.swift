//
//  TravellerData+CoreDataProperties.swift
//
//
//  Created by Admin on 09/01/19.
//
//

import Foundation
import CoreData


extension TravellerData {
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TravellerData> {
        return NSFetchRequest<TravellerData>(entityName: "TravellerData")
    }
    
    @NSManaged public var dob: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var label: String?
    @NSManaged public var lastName: String?
    @NSManaged public var salutation: String?
    @NSManaged public var firstNameFirstChar:String?
    @NSManaged public var lastNameFirstChar:String?
    
}
