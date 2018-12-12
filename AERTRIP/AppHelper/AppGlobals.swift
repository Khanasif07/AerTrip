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
    
    func showError(message: String) {
    }
    
    func showWarning(message: String) {
        printDebug(message)
    }
    
    static func lines(label: UILabel) -> Int {
        
        let textSize  = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight   = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize  = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
}


