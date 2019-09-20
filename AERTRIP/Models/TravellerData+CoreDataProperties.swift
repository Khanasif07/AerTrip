//
import CoreData
import Foundation
//  TravellerData+CoreDataProperties.swift
//
//
//  Created by Admin on 09/01/19.
//
//
import UIKit

extension TravellerData {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TravellerData> {
        return NSFetchRequest<TravellerData>(entityName: "TravellerData")
    }
    
    @NSManaged public var dob: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var label: String?
    @NSManaged public var labelLocPrio: String?
    @NSManaged public var lastName: String?
    @NSManaged public var salutation: String?
    @NSManaged public var firstNameFirstChar: String?
    @NSManaged public var lastNameFirstChar: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var profileImage: String
}

extension TravellerData {
    var age: Int {
        return dob?.toDate(dateFormat: "yyyy-MM-dd")?.month ?? 0
    }
    
    var travellerDetailModel: TravelDetailModel {
        var temp = TravelDetailModel(json: JSON([:]))
        temp.id = self.id ?? ""
        temp.firstName = self.firstName ?? ""
        temp.dob = self.dob ?? ""
        temp.label = self.label ?? ""
        temp.lastName = self.lastName ?? ""
        temp.salutation = self.salutation ?? ""
        temp.profileImage = self.profileImage
        return temp
    }
    
    var salutationImage: UIImage {
        switch salutation {
        case "Mrs":
            return #imageLiteral(resourceName: "woman")
        case "Mr":
            return #imageLiteral(resourceName: "man")
        case "Mast":
            return #imageLiteral(resourceName: "man")
        case "Miss":
            return #imageLiteral(resourceName: "girl")
        case "Ms":
            return #imageLiteral(resourceName: "woman")
        default:
            return #imageLiteral(resourceName: "person")
        }
    }
}
