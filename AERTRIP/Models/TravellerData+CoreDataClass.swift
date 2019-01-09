//
//  TravellerData+CoreDataClass.swift
//  
//
//  Created by Admin on 09/01/19.
//
//

import Foundation
import CoreData

@objc(TravellerData)
public class TravellerData: NSManagedObject {
    
    //MARK:- Insert Single Data
    //MARK:-
    class func insert(dataDict: JSONDictionary)-> TravellerData {
        
        var userData: TravellerData?
        
        if let id = dataDict[APIKeys.id.rawValue], !"\(id)".isEmpty {
            userData = TravellerData.fetch(travId: "\(id)")
        }
        
        if (userData == nil) {
            userData = NSEntityDescription.insertNewObject(forEntityName: "TravellerData", into: CoreDataManager.shared.managedObjectContext) as? TravellerData
        }
        
        if let obj = dataDict[APIKeys.id.rawValue] {
            userData!.id = "\(obj)"
        }
        
        if let obj = dataDict[APIKeys.dob.rawValue] {
            userData!.dob = "\(obj)"
        }
        
        if let obj = dataDict[APIKeys.firstName.rawValue] {
            userData!.firstName = "\(obj)"
        }
        
        if let obj = dataDict[APIKeys.label.rawValue] {
            userData!.label = "\(obj)"
        }
        
        if let obj = dataDict[APIKeys.lastName.rawValue] {
            userData!.lastName = "\(obj)"
        }
        
        if let obj = dataDict[APIKeys.salutation.rawValue] {
            userData!.salutation = "\(obj)"
        }
        
        CoreDataManager.shared.saveContext()
        
        return userData!
    }
    
    
    //MARK:- Insert Bulk Data
    //MARK:-
    class func insert(dataDictArray: JSONDictionaryArray, completionBlock:@escaping ([TravellerData]) -> Void) {
        
        var dataArr = [TravellerData]()
        var tempDataArr = [TravellerData]()
        // set up a managed object context just for the insert. This is in addition to the managed object context you may have in your App Delegate.
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.parent = CoreDataManager.shared.managedObjectContext
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        
        managedObjectContext.perform { // runs asynchronously
            
            while(true) { // loop through each batch of inserts. Your implementation may vary.
                
                autoreleasepool { // auto release objects after the batch save
                    
                    // insert new entity object
                    for dataDict in dataDictArray {
                        let dataTemp = TravellerData.insert(dataDict: dataDict)
                        dataArr.append(dataTemp)
                    }
                }
                
                // only save once per batch insert
                do {
                    try managedObjectContext.save()
                }
                catch let error {
                    printDebug("Problem in saving the managedObjectContext while in bulk is: \(error.localizedDescription)")
                }
                
                CoreDataManager.shared.managedObjectContext.perform({
                    
                    if CoreDataManager.shared.managedObjectContext.hasChanges{
                        do {
                            try CoreDataManager.shared.managedObjectContext.save()
                        }
                        catch let error {
                            printDebug("Problem in saving the managedObjectContext while in bulk is: \(error.localizedDescription)")
                        }
                    }
                    for dataTemp in dataArr {
                        let data = CoreDataManager.shared.managedObjectContext.object(with: dataTemp.objectID) as! TravellerData
                        tempDataArr.append(data)
                    }
                    completionBlock(tempDataArr)
                })
                return
            }
        }
    }
    
    //MARK:- Check Whether Value Exist or Not
    //MARK:-
    class func fetch(travId: String?) -> TravellerData? {
        
        var predicateStr = ""
        if let id = travId {
            predicateStr = "id = '\(id)'"
        }
        
        if let fetchResult = CoreDataManager.shared.fetchData("TravellerData", predicate: predicateStr, sort: nil) {
            if (!fetchResult.isEmpty) {
                return fetchResult[0] as? TravellerData
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

