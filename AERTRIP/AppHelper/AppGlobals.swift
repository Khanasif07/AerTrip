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
    
    func json(from object:Any) -> String? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func onject(from json:String) -> Any? {
        
        if let data = json.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        }
        return nil
    }
    
    static func retunsStringArray(jsonArr:[JSON]) -> [String] {
        var labels = [String]()
        for element in jsonArr {
            
            labels.append(element["display_order"].stringValue)
        }
        return labels
    }
    
     func getImageFromText(_ fromText: String) -> UIImage {
        return UIImage(text: fromText, font: UIFont.systemFont(ofSize: 20.0), color: AppColors.themeGray40, backgroundColor: UIColor.white, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 0, y: 12))!
    }

    func showErrorOnToastView(errors: ErrorCodes, viewController: UIViewController) {
        
        var message = ""
        for index in 0..<errors.count {
            if index == 0 {
                
                message = AppErrorCodeFor(rawValue: errors[index])?.message ?? ""
            } else {
                message += ", " + (AppErrorCodeFor(rawValue: errors[index])?.message ?? "")
            }
        }
        AppToast.default.showToastMessage(message: message, vc: viewController)
    }
    
    // convert Date from one format to another
    
    func formattedDateFromString(dateString: String,inputFormat iF : String, withFormat outputFormat: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = iF
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}


