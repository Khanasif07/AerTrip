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
        
        if let obj = dataDict[APIKeys.firstName.rawValue] as? String {
            userData!.firstName = "\(obj.capitalizedFirst())".removeNull
            
            let firstChar = "\(userData!.firstName?.firstCharacter ?? "N")".uppercased()
            let alphaArr = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            
            if alphaArr.contains(firstChar) {
                userData!.firstNameFirstChar = firstChar
            }
            else {
                userData!.firstNameFirstChar = "#"
            }
        }
        
        if let obj = dataDict[APIKeys.label.rawValue] as? String {
            if obj.isEmpty {
                userData!.label = "Others"
            }
            else {
                userData!.label = "\(obj)".removeNull.removeLeadingTrailingWhitespaces
            }
            
            if let allData = UserInfo.loggedInUser?.generalPref?.labelsWithPriority, let prio = allData[userData!.label!] {
                userData!.labelLocPrio = "\(prio)"
            }
        }
        if let obj = dataDict[APIKeys.lastName.rawValue] as? String {
            userData!.lastName = "\(obj)".removeNull
            userData!.lastNameFirstChar = "\(userData!.lastName?.firstCharacter ?? "N")"
        }
        
        if let obj = dataDict[APIKeys.salutation.rawValue] {
            userData!.salutation = "\(obj)".removeNull
        }
        
        CoreDataManager.shared.saveContext(managedContext: context)
        
        return userData!
    }
    
    // MARK: - Insert Bulk Data
    
    // MARK: -
    
    class func insert(dataDictArray: [TravellerModel], completionBlock: @escaping ([TravellerData]) -> Void) {
        
        for dataDict in dataDictArray {
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
