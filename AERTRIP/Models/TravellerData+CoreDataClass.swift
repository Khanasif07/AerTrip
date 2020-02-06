//
//  TravellerData+CoreDataClass.swift
//
//
//  Created by Admin on 09/01/19.
//
//

import CoreData
import Foundation

@objc(TravellerData)
public class TravellerData: NSManagedObject {
    // MARK: - Insert Single Data
    
    // MARK: -
    
    class func insert(dataDict: JSONDictionary, into context: NSManagedObjectContext = CoreDataManager.shared.managedObjectContext) -> TravellerData {
        var userData: TravellerData?
        
        if let id = dataDict[APIKeys.id.rawValue], !"\(id)".isEmpty {
            userData = TravellerData.fetch(id: "\(id)")
        }
        
        if userData == nil {
            userData = NSEntityDescription.insertNewObject(forEntityName: "TravellerData", into: context) as? TravellerData
        }
        
        if let obj = dataDict[APIKeys.id.rawValue] {
            userData!.id = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.dob.rawValue] {
            userData!.dob = "\(obj)".removeNull
        }
        
        if let firstname = dataDict[APIKeys.firstName.rawValue] as? String, let lastname = dataDict[APIKeys.lastName.rawValue] as? String {
            let firstName = "\(firstname)".removeNull.removeLeadingTrailingWhitespaces
            let lastName = "\(lastname)".removeNull.removeLeadingTrailingWhitespaces

            userData!.firstName = "\(firstName.capitalizedFirst())"
            // keys for sorting purpose
            userData!.firstNameSorting = firstName
            userData!.lastNameSorting = lastName

            if !lastName.isEmpty {
                userData!.lastName = lastName
            }else {
                userData!.lastNameSorting = firstName
            }
                    
        let firstNameFirstChar = firstName.firstCharacter.uppercased()
        let lastNameFirstChar = lastName.firstCharacter.uppercased()

        let alphaArr = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
            printDebug("firstName: \(firstName)")
            printDebug("lastName: \(lastName)")

        if (firstNameFirstChar.isEmpty || firstNameFirstChar == " ") && (lastNameFirstChar.isEmpty || lastNameFirstChar == " ") {
            userData!.firstNameFirstChar = "#"
            userData!.lastNameFirstChar = "#"
        } else if !(firstNameFirstChar.isEmpty || firstNameFirstChar == " ") && !(lastNameFirstChar.isEmpty || lastNameFirstChar == " ") {
            if alphaArr.contains(firstNameFirstChar) {
                userData!.firstNameFirstChar = firstNameFirstChar
            }
            else {
                userData!.firstNameFirstChar = "#"
            }
            if alphaArr.contains(lastNameFirstChar) {
                userData!.lastNameFirstChar = lastNameFirstChar
            }
            else {
                userData!.lastNameFirstChar = "#"
            }
        }else if !(firstNameFirstChar.isEmpty || firstNameFirstChar == " ") && (lastNameFirstChar.isEmpty || lastNameFirstChar == " ") {
            if alphaArr.contains(firstNameFirstChar) {
                userData!.firstNameFirstChar = firstNameFirstChar
                userData!.lastNameFirstChar = firstNameFirstChar
            }
            else {
                userData!.firstNameFirstChar = "#"
                userData!.lastNameFirstChar = "#"
            }
        }else if (firstNameFirstChar.isEmpty || firstNameFirstChar == " ") && !(lastNameFirstChar.isEmpty || lastNameFirstChar == " ") {
            if alphaArr.contains(lastNameFirstChar) {
                userData!.firstNameFirstChar = lastNameFirstChar
                userData!.lastNameFirstChar = lastNameFirstChar
            }
            else {
                userData!.firstNameFirstChar = "#"
                userData!.lastNameFirstChar = "#"
            }
        }
            printDebug("firstNameFirstChar: \(userData!.firstNameFirstChar)")
            printDebug("lastNameFirstChar: \(userData!.lastNameFirstChar)")
        }
        
        
        if let obj = dataDict[APIKeys.label.rawValue] as? String {
            let defaultLabel = "Others"
            if obj.isEmpty {
                userData!.label = defaultLabel
            }
            else {
                userData!.label = "\(obj)".removeNull.removeLeadingTrailingWhitespaces
            }
            let allData = UserInfo.loggedInUser?.generalPref?.labelsWithPriority ?? [:]
            if let prio = allData[userData!.label!] {
                userData!.labelLocPrio = Int16(prio)
            } else if let prio = allData[defaultLabel] {
                userData!.label = defaultLabel
                userData!.labelLocPrio = Int16(prio)
            }
        }
        
        if let obj = dataDict[APIKeys.salutation.rawValue] {
            userData!.salutation = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.profileImg.rawValue] {
            userData?.profileImage = "\(obj)".removeNull
        }
        
        let completeName = "\(userData?.firstName ?? "") \(userData?.lastName ?? "")"
        userData?.fullName = completeName.removeLeadingTrailingWhitespaces
        
        CoreDataManager.shared.saveContext(managedContext: context)
        
        return userData!
    }
    
    // MARK: - Insert Bulk Data
    
    // MARK: -
    
    class func insert(dataDictArray: [TravellerModel], completionBlock: @escaping ([TravellerData]) -> Void) {
        
        for dataDict in dataDictArray {
            guard let id = dataDict.jsonDict[APIKeys.id.rawValue], let logedinUserId = UserInfo.loggedInUserId, logedinUserId != "\(id)".removeNull.removeNull else {
                // checking if loged in user is comming then don't add
                continue
            }
            let _ = TravellerData.insert(dataDict: dataDict.jsonDict)
        }
        completionBlock([])
    }
    
    // MARK: - Check Whether Value Exist or Not
    
    // MARK: -
    
    class func fetch(id: String?) -> TravellerData? {
        var predicateStr = ""
        if let id = id {
            predicateStr = "id BEGINSWITH '\(id)'"
        }
        
        if let fetchResult = CoreDataManager.shared.fetchData("TravellerData", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult[0] as? TravellerData
            }
            return nil
        }
        return nil
    }
    
    class func fetch(forLabel: String) -> [TravellerData]? {
        let predicateStr = "label LIKE '\(forLabel)'"
        
        if let fetchResult = CoreDataManager.shared.fetchData("TravellerData", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult as? [TravellerData]
            }
            return nil
        }
        return nil
    }
}

extension TravellerData {
    var dict: JSONDictionary {
        var dict = JSONDictionary()
        dict[APIKeys.id.rawValue] = self.id ?? ""
        dict[APIKeys.dob.rawValue] = self.dob ?? ""
        dict[APIKeys.firstName.rawValue] = self.firstName ?? ""
        dict[APIKeys.label.rawValue] = self.label ?? ""
        dict[APIKeys.lastName.rawValue] = self.lastName ?? ""
        dict[APIKeys.salutation.rawValue] = self.salutation ?? ""
        
        return dict
    }
    
    var toString: String? {
        if let data = try? JSONSerialization.data(withJSONObject: self.dict, options: JSONSerialization.WritingOptions.prettyPrinted) {
            return String(data: data, encoding: String.Encoding.ascii)
        }
        return nil
    }
}
