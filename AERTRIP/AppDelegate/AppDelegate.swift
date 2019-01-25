//
//  AppDelegate.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import GoogleSignIn
import LinkedinSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let transitionCoordinator = TransitionCoordinator()
    static var shared = UIApplication.shared.delegate as! AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GoogleLoginController.shared.configure()
        AppFlowManager.default.setupInitialFlow()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
       // self.saveContext()
    }
    
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // ...
            guard let  url = dynamiclink?.url else {return}
            
            if url.absoluteString.contains("email=") && url.absoluteString.contains("&ref") {
                
                guard let email = url.absoluteString.slice(from: "email=", to: "&ref") else {return}
                guard let ref   = url.absoluteString.components(separatedBy: "&ref=").last else {return}
                AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkSetPassword, email: email, refId: ref)
                
            } else if url.absoluteString.contains("&key=") && url.absoluteString.contains("&token=") && url.absoluteString.contains("&email=") {
                
                guard let ref   = url.absoluteString.slice(from: "&key=", to: "&token=") else {return}
                guard let token   = url.absoluteString.slice(from: "&token=", to: "&email=") else {return}
                guard let email = url.absoluteString.components(separatedBy: "&email=").last else {return}
                AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkResetPassword, email: email, refId: ref, token: token)
            }
        }
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        if url.scheme?.lowercased() == AppConstants.fbUrl {
            return FBSDKApplicationDelegate.sharedInstance().application(application,open: url,sourceApplication: sourceApplication, annotation: annotation)
        }
        else if url.scheme?.lowercased() == AppConstants.googleUrl {
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        }
        else if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation
            )
        }
        
        return true
    }
//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = NSPersistentContainer(name: "AERTRIP")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    // MARK: - Core Data Saving support
    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    
}

