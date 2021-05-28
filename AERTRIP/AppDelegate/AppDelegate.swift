//
//  AppDelegate.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import CoreData
import FBSDKLoginKit
import Firebase
import GoogleMaps
import GoogleSignIn
//import LinkedinSwiftr
import FirebaseDynamicLinks
import FirebaseCore
import UIKit
import IQKeyboardManager
import Kingfisher

var isSEDevice = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let transitionCoordinator = TransitionCoordinator()
    static var shared = UIApplication.shared.delegate as! AppDelegate
    
    var upgradePlanData = [OtherFareCache]()
    var upgradeDataMutableArray = NSMutableArray()
    var flightPerformanceMutableArray = NSMutableArray()
    var flightBaggageMutableArray = NSMutableArray()
    var flightFareInfoMutableArray = [[String:Any]]()
    
    private var reachability: Reachability?
    
    //com.aertrip.app
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // CHECK FOR LAUNCH OF FLIGHT OR HOTEL MODULE        
        FirebaseApp.configure()
        AppFlowManager.default.setupSplashAnimationFlow()
        window?.backgroundColor = UIColor.black
        
        GoogleLoginController.shared.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(AppKeys.kGoogleAPIKey)
        UITextView.appearance().tintColor = AppColors.themeGreen
        UITextField.appearance().tintColor = AppColors.themeGreen
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkForReachability(_:)), name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        self.reachability = Reachability.networkReachabilityForInternetConnection()
        let _ = self.reachability?.startNotifier()
        UserDefaults.standard.set(false, forKey: "NSAllowsDefaultLineBreakStrategy")
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
//        ImageCache.default.memoryStorage.config.totalCostLimit = 100
//        ImageCache.default.cleanExpiredCache()
        
        
        if UIDevice.current.name.contains(find: "SE"){
            isSEDevice = true
        }else{
            isSEDevice = false
        }
        
        FirebaseEventLogs.shared.logAppOpenEvent()

        CurrencyControler.shared.setSelectedCurrency(currency: UserInfo.preferredCurrencyDetails)
       
        CurrencyControler.shared.getCurrencies { (success, currencies, topCurrencies) in }
        
        CurrencyControler.shared.scheduleCurrencyTimer()
                        
        return true
    }
    
    @objc func checkForReachability(_ notification: Notification) {
        
        guard let networkReachability = notification.object as? Reachability else {return}
        let remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if remoteHostStatus == .notReachable {
            AppGlobals.shared.stopLoading()
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        }
        else if remoteHostStatus == .reachableViaWiFi {
            printDebug("Reachable via Wifi")
        }
        else {
            printDebug("Reachable")
        }
    }
    
    func setupFlightsVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeDummyViewController = HomeDummyViewController()
        let navigationViewController = UINavigationController(rootViewController: homeDummyViewController)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CurrencyControler.shared.getCurrencies { (success, currencies, topCurrencies) in }

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        VersionControler.shared.checkForUpdate()
        
        CurrencyControler.shared.getCurrencies { (success, currencies, topCurrencies) in }

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
        
        guard let url = userActivity.webpageURL else { return false }
        
        if url.absoluteString.contains("?ref") {
            guard let ref = url.absoluteString.components(separatedBy: "?ref=").last else { return false}
            AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkSetPassword, email: "", refId: ref)
        }
        else if url.absoluteString.contains("email="), url.absoluteString.contains("&ref") {
            guard let email = url.absoluteString.slice(from: "email=", to: "&ref") else { return false}
            guard let ref = url.absoluteString.components(separatedBy: "&ref=").last else { return false}
            AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkSetPassword, email: email, refId: ref)
        }
        else if url.absoluteString.contains("?key="), url.absoluteString.contains("&token=") {
            guard let ref = url.absoluteString.slice(from: "?key=", to: "&token=") else { return false}
            guard let token = url.absoluteString.components(separatedBy: "&token=").last else { return false}
            AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkResetPassword, email: "", refId: ref, token: token)
        } else {
            checkForFlightsAndHotelsDeepLink(url: url)
        }
        
        return true
        //        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { dynamiclink, _ in
        //            // ...
        //            guard let url = dynamiclink?.url else { return }
        //
        //            if url.absoluteString.contains("email="), url.absoluteString.contains("&ref") {
        //                guard let email = url.absoluteString.slice(from: "email=", to: "&ref") else { return }
        //                guard let ref = url.absoluteString.components(separatedBy: "&ref=").last else { return }
        //                AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkSetPassword, email: email, refId: ref)
        //            }
        //            else if url.absoluteString.contains("&key="), url.absoluteString.contains("&token="), url.absoluteString.contains("&email=") {
        //                guard let ref = url.absoluteString.slice(from: "&key=", to: "&token=") else { return }
        //                guard let token = url.absoluteString.slice(from: "&token=", to: "&email=") else { return }
        //                guard let email = url.absoluteString.components(separatedBy: "&email=").last else { return }
        //                AppFlowManager.default.deeplinkToRegistrationSuccefullyVC(type: .deeplinkResetPassword, email: email, refId: ref, token: token)
        //            }
        //        }
        //        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme?.lowercased() == AppKeys.fbUrl {
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if url.scheme?.lowercased() == AppKeys.googleUrl {
            return GIDSignIn.sharedInstance().handle(url)
            
        } else {
            checkForFlightsAndHotelsDeepLink(url: url)
        }

        return true
    }
    
    func checkForFlightsAndHotelsDeepLink(url: URL?) {
        let str = url?.absoluteString
        var newStr: String?
        
        if (str as NSString?)?.range(of: "https").location != NSNotFound {
            newStr = str?.replacingOccurrences(of: "aertrip://https", with: "https:")
        } else {
            if (str as NSString?)?.range(of: "http").location != NSNotFound {
                newStr = str?.replacingOccurrences(of: "aertrip://http", with: "http:")
            }
        }
        
        let newUrl = URL(string: newStr ?? "")
        
        newUrl?.expandURLWithCompletionHandler(completionHandler: {[weak self] url in
            guard let self = self else { return }
            if let url = url {
                printDebug("expandedUrl=\(url)")
            }
            
            let str = url?.query ?? ""
            let decodedUrl = str.removingPercentEncoding
            
            var pairs: [String : Any] = [:]
            
            for pairString in decodedUrl?.components(separatedBy: "&") ?? [] {
                let pair = pairString.components(separatedBy: "=")
                
                if pair.count != 2 {
                    continue
                }
                
                let key = pair[0]
                let val = pair[1]
                
                if val.isEmpty {
                    continue
                }

                pairs[key] = val.replacingOccurrences(of: "+", with: " ")
            }
            
            self.moveToRootVC()
            if url?.absoluteString.contains("flights") ?? false {
                self.searchFlightsWithDeepLink(dict: pairs)
            } else if url?.absoluteString.contains("hotels") ?? false {
                self.searchHotelsWithDeepLink(dict: pairs)
            }else if url?.absoluteString.contains("booking") ?? false {
                let bookingId = pairs["bid"] as? String ?? ""
                let isCompleted = (url?.absoluteString.contains("past") ?? false)
                self.openMyBookingVCFromDeepLink(bookingId: bookingId, isCompleted: isCompleted)
            }else if url?.absoluteString.contains("account") ?? false{
                let pair = pairs as? [String:String] ?? [:]
                self.openAccountVCFromDeepLink(with: pair)
            }
        })
    }
    
    func searchFlightsWithDeepLink(dict: JSONDictionary) {
        
        DispatchQueue.main.async {
            
            if let rootVC = self.window?.rootViewController as? UINavigationController {
                if let vc = rootVC.viewControllers.first(where: {$0.isKind(of: FlightResultBaseViewController.self)}) as? FlightResultBaseViewController{
                    vc.popToPreviousScreen(sender: UIButton())
                    rootVC.dismiss(animated: true, completion: nil)
                }
            }
        }
        DispatchQueue.delay(1) {
            guard let dashboardVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first?.children.first?.children.first as? DashboardVC else { return }
            dashboardVC.flightsAction(UIButton())
            if !dict.isEmpty {
                SwiftObjCBridgingController.shared.sendFlightFormData(dict)
            }
        }
    }
    
    func searchHotelsWithDeepLink(dict: JSONDictionary) {
        let formJson = JSON(dict)
        var recentSearchModel = RecentSearchesModel()
        var adultsArr = [String]()
        var childArr = [[Child]]()
        for roomIndex in 0..<4 {
            if formJson["r\(roomIndex)a"].stringValue.isEmpty { break } else {
                adultsArr.append(formJson["r\(roomIndex)a"].stringValue)
            }
            var roomChildArr = [Child]()
            for childIndex in 0..<4 {
                if formJson["r\(roomIndex)c\(childIndex)"].stringValue.isEmpty { break }
                var child = Child()
                child.childAge = formJson["r\(roomIndex)c\(childIndex)"].intValue
                child.isPresent = true
                child.error = false
                roomChildArr.append(child)
            }
            childArr.append(roomChildArr)
        }
        
        var roomArr = [RecentRoom]()
        adultsArr.enumerated().forEach { (index, adultCount) in
            var room = RecentRoom()
            room.adultCounts = adultCount
            if childArr.indices.contains(index) {
                room.child = childArr[index]
            }
            room.isPresent = true
            roomArr.append(room)
        }
        
        recentSearchModel.room = roomArr
        recentSearchModel.checkInDate = formJson[APIKeys.checkin.rawValue].stringValue
        recentSearchModel.checkOutDate = formJson[APIKeys.checkout.rawValue].stringValue
        recentSearchModel.dest_id = formJson[APIKeys.dest_id.rawValue].stringValue
        recentSearchModel.dest_type = formJson[APIKeys.dest_type.rawValue].stringValue
        recentSearchModel.dest_name = formJson[APIKeys.dest_name.rawValue].stringValue
        recentSearchModel.totalNights = formJson[APIKeys.nights.rawValue].intValue
        recentSearchModel.guestsValue = formJson[APIKeys.guests.rawValue].stringValue
        recentSearchModel.lat = formJson[APIKeys.lat.rawValue].stringValue
        recentSearchModel.lng = formJson[APIKeys.lng.rawValue].stringValue
        recentSearchModel.type = .hotel
        
        if let filterDict = AppGlobals.shared.object(from: formJson[APIKeys.filter.rawValue].stringValue) as? JSONDictionary {
            recentSearchModel.filter = RecentSearchesFilter(json: filterDict)
        }
        DispatchQueue.delay(1) {
            guard let dashboardVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first?.children.first?.children.first as? DashboardVC else { return }
            
            dashboardVC.hotelsAction(UIButton())
            dashboardVC.children.forEach { (viewCon) in
                if let searchVC = viewCon as? HotelsSearchVC, !dict.isEmpty {
                    delay(seconds: 1.0) {
                        searchVC.passRecentSearchesData(recentSearch: recentSearchModel)
                    }
                }
            }
        }
    }
    
    private func moveToRootVC() {
        DispatchQueue.main.async {
            
            if AppFlowManager.default.sideMenuController?.isOpen ?? false {
                AppFlowManager.default.sideMenuController?.closeMenu()
            }
            
            let nvc = self.window?.rootViewController as? UINavigationController
            
            nvc?.dismiss(animated: true, completion: {
                nvc?.popToRootViewController(animated: true)
            })
            
//            guard let dashboardVC = nvc?.viewControllers.first?.children.first?.children.first as? DashboardVC else { return }
//            if dashboardVC.mainScrollView.contentOffset.x > 0 {
//                ma
//            }
        }
    }
    
    
    func openAccountVCFromDeepLink(with param:[String:String]){
        self.moveToRootVC()
        delay(seconds: 1) {
            guard let dashboardVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first?.children.first?.children.first as? DashboardVC else { return }
            dashboardVC.profileButtonAction(ATNotificationButton())
            AppFlowManager.default.moveToAccountDetailsScreen(with: param)
        }
    }
    
    
    func openMyBookingVCFromDeepLink(bookingId: String, isCompleted:Bool){
        self.moveToRootVC()
        delay(seconds: 1) {
            guard let dashboardVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first?.children.first?.children.first as? DashboardVC else { return }
            dashboardVC.profileButtonAction(ATNotificationButton())
            AppFlowManager.default.moveToMyBookingsVC(bookingId: bookingId, isCompleted: isCompleted)
        }
    }

}
