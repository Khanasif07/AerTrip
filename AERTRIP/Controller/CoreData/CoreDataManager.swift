//
//  CoreDataManager.swift
//
//  Created by Pramod Kumar on 30/10/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import CoreData
import UIKit


/**
 * A collection of helper functions for saving and retrieve data from core data
 */
class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK:- Core Data stack
    //MARK:-
    lazy var applicationDocumentsDirectory: URL = {
        /**
         * The directory the application uses to store the Core Data store file. This code uses a directory named "AppInventiv.wyndu" in the application's documents Application Support directory.
         */
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls[urls.count-1]
        printDebug("Aertrip Traveller Data at: \(url)")
        return url
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AERTRIP")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedObjectModel: NSManagedObjectModel {
        /**
         * The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
         */
        
        return persistentContainer.managedObjectModel
    }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        /**
         * The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
         * Create the coordinator and store
         */
        
        return persistentContainer.persistentStoreCoordinator
    }
    
    var managedObjectContext: NSManagedObjectContext {
        /**
         * Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
         */
        return persistentContainer.viewContext
    }

    /**
     * Making init private so that other object cann't be created.
     */
    private init() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        printDebug("Aertrip sqlite path: \(paths[0])")
    }
    
    //MARK:- Commit/Save In Coredata
    //MARK:-
    
    /**
     * Saves the context that specified.
     * @managedContext: If passed as nil or nothing saves the current working context, otherwise the specified one.
     */
    func saveContext(managedContext: NSManagedObjectContext? = nil) {
       // DispatchQueue.main.async {
            var contextToSave: NSManagedObjectContext?
            if let context = managedContext {
                contextToSave = context
            }
            else {
                contextToSave = self.managedObjectContext
            }
            
            if contextToSave!.hasChanges {
                do {
                    try contextToSave!.save()
                }
                catch let error {
                    printDebug("Problem in saving the managedObjectContext is: \(error.localizedDescription)")
                }
            }
       //}
    }
    
    /**
     * Rollback the current working context with the previous saved context.
     */
    func rollBackContext() {
        self.managedObjectContext.rollback()
    }
    
    //MARK:- Delete Form Core Data
    //MARK:-
    func deleteAllData(_ modelName: String) -> Bool {
        if let result = self.fetchData(modelName) {
            for resultItem in result {
                let finalItem: AnyObject = resultItem as AnyObject
                self.managedObjectContext.delete(finalItem as! NSManagedObject)
            }
            self.saveContext()
            return true
        }
        return false
    }
    
    func deleteData(_ modelName: String, predicate: String?)-> Bool {
        if let result = self.fetchData(modelName, predicate: predicate) {
            for resultItem in result {
                let finalItem: AnyObject = resultItem as AnyObject
                self.managedObjectContext.delete(finalItem as! NSManagedObject)
            }
            self.saveContext()
            return true
        }
        return false
    }
    
    func deleteCompleteDB() {
        
        guard let persistentStore = persistentStoreCoordinator.persistentStores.last else {
            return
        }
        
        let url = persistentStoreCoordinator.url(for: persistentStore)
        managedObjectContext.reset()
        do {
            try persistentStoreCoordinator.remove(persistentStore)
            try FileManager.default.removeItem(at: url)
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch let error {
            /*dealing with errors up to the usage*/
            printDebug("Problem in deleting complete data from core data is: \(error.localizedDescription)")
        }
    }
    
    //MARK:- Fetch Data From Core Data
    //MARK:-
    func fetchData(_ modelName: String, predicate:String? = nil, sort:[(sortKey:String?,isAscending:Bool)]? = nil, inManagedContext: NSManagedObjectContext? = CoreDataManager.shared.managedObjectContext) -> [Any]? {
        
        let cdhObj = inManagedContext!
        
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        //set predicate
        if let prdStr = predicate {
            fReq.predicate = NSPredicate(format:prdStr)
        }
        
        //set sort descripter
        if let sortDict = sort {
            var sorterArr = [NSSortDescriptor]()
            for shortValue in sortDict {
                //Check whether sorting is to be applied
                if let sortKey = shortValue.sortKey {
                    let sorter: NSSortDescriptor = NSSortDescriptor(key: sortKey , ascending: shortValue.isAscending)
                    sorterArr.append(sorter)
                }
            }
            if sorterArr.count > 0{
                fReq.sortDescriptors = sorterArr
            }
        }
        fReq.returnsObjectsAsFaults = false
        
        
        //final fetch data
        do {
            let result = try cdhObj.fetch(fReq)
            return result
        }
        catch let error {
            printDebug("Problem in fetching data from core data is: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchData(fromEntity: String, forAttribute: String, usingFunction function: String) -> [JSONDictionary] {
        /*
         Function ca be like:
         count  :::  use to get the count for perticular attribute
         max    :::  use to get the maximum value for perticular attribute
         min    :::  use to get the minimum value for perticular attribute
        */
        let keypathExp = NSExpression(forKeyPath: forAttribute)
        let expression = NSExpression(forFunction: "\(function):", arguments: [keypathExp])
        
        let funcDesc = NSExpressionDescription()
        funcDesc.expression = expression
        funcDesc.name = function
        funcDesc.expressionResultType = (function.lowercased() == "count") ? .decimalAttributeType : .stringAttributeType
        
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: fromEntity)
        
        request.returnsObjectsAsFaults = false
        if function.lowercased() == "count" {
            request.propertiesToGroupBy = [forAttribute]
            request.propertiesToFetch = [forAttribute, funcDesc]
        }
        else {
            request.propertiesToFetch = [funcDesc]
        }
        request.resultType = .dictionaryResultType
        
        //final fetch data
        do {
            let result = try CoreDataManager.shared.managedObjectContext.fetch(request) as? [JSONDictionary]
            return result ?? [[:]]
        }
        catch let error {
            printDebug("Problem in fetching data from core data is: \(error.localizedDescription)")
            return [[:]]
        }
    }
}
