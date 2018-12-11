//
//  Globals.swift
//  
//
//  Created by Pramod Kumar on 09/03/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

func printDebug<T>(_ obj : T) {
    print(obj)
}

func printFonts() {
    for family in UIFont.familyNames {
        let fontsName = UIFont.fontNames(forFamilyName: family)
        printDebug(fontsName)
    }
}

func delay(seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}


struct AppGlobals {
    static let shared = AppGlobals()
    private init() {}
    
    func showSuccess(message: String) {
       printDebug(message)
    }
    
    func showError(message: String, vc: UIViewController, isRightImageButton: Bool = false, rightButtonTitle: String = "") {
        printDebug(message)
        
        let ob = ShowToastMessageVC.instantiate(fromAppStoryboard: .PreLogin)
        
        ob.message = message
        ob.isRightButtonImage  = isRightImageButton
        ob.rightButtonTitle   = rightButtonTitle
        vc.view.addSubview(ob.view)
        vc.add(childViewController: ob)
    }
    
    func showWarning(message: String) {
        printDebug(message)
    }
}


