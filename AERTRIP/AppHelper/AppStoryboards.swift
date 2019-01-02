//
//  AppStoryboards.swift
//  AppUserDefaults
//
//  Created by Pramod Kumar on 15/12/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case PreLogin
    case Splash
    case Dashboard
    case Profile
    case HotelPreferences
}

extension AppStoryboard {

    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func getStoryBoard(name:AppStoryboard) -> UIStoryboard {
        return UIStoryboard.init(name: name.rawValue, bundle: nil)
    }
    
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(self)
    }
}

