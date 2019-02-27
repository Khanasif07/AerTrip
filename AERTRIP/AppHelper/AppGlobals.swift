//
//  Globals.swift
//  
//
//  Created by Pramod Kumar on 09/03/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManager

func printDebug<T>(_ obj : T) {
//    print(obj)
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
    
    func updateIQToolBarDoneButton(isEnabled: Bool, onView: UIView? = nil) {
        onView?.keyboardToolbar.doneBarButton.isEnabled = isEnabled
        IQKeyboardManager.shared().toolbarDoneBarButtonItemText = isEnabled ? LocalizedString.Done.localized : ""
    }
    
    func getImageFor(firstName: String?, lastName: String?, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12)) -> UIImage {
        
        let string = "\((firstName ?? "F").firstCharacter)\((lastName ?? "L").firstCharacter)".uppercased()
        return self.getImageFromText(string, font: font, textColor: textColor, offSet: offSet)
    }
    
    func getImageFromText(_ fromText: String, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12)) -> UIImage {
        let size = 70.0
        return UIImage(text: fromText, font: font, color: textColor, backgroundColor: UIColor.white, size: CGSize(width: size, height: size), offset: offSet)!
    }

    func showErrorOnToastView(withErrors errors: ErrorCodes, fromModule module: ATErrorManager.Module) {
        
        let (_, message) = ATErrorManager.default.error(forCodes: errors, module: module)
        AppToast.default.showToastMessage(message: message)
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
    
    func getPKAlertButtons(forTitles: [String], colors: [UIColor]) -> [PKAlertButton] {
        guard forTitles.count == colors.count else {
            fatalError("Please send the titles and colors equally")
        }
        var temp = [PKAlertButton]()
        for (idx, title) in forTitles.enumerated() {
            temp.append(PKAlertButton(title: title, titleColor: colors[idx]))
        }
        
        return temp
    }
    
    var pKAlertCancelButton: PKAlertButton {
        return PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeGreen)
    }
    
    
    func saveImage(data: Data) -> String {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = "\(UIDevice.uuidString).jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        
        FileManager.removeFile(atPath: fileURL.path)
        do {
            // writes the image data to disk
            try data.write(to: fileURL)
            printDebug("file saved")
            return fileURL.path
        } catch {
            printDebug("error saving file:")
            return ""
        }
    }
    
    func getTextWithImage(startText: String, image: UIImage, endText: String, font: UIFont) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: startText)
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()

        //        image1Attachment.bounds.origin = CGPoint(x: 0.0, y: 5.0)
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: endText))
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }

    func getTextWithImageWithLink(startText: String, startTextColor: UIColor, middleText: String , image: UIImage, endText: String,endTextColor: UIColor , middleTextColor: UIColor , font: UIFont) -> NSMutableAttributedString {
        
        let fullString = NSMutableAttributedString()
        
        //Start Text SetUp
        let startTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: startTextColor] as [NSAttributedString.Key : Any]
        let startAttributedString = NSAttributedString(string: startText, attributes: startTextAttribute)
        
        //Middle Text SetUp
        let middleTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: middleTextColor] as [NSAttributedString.Key : Any]
        let middleAttributedString = NSAttributedString(string: middleText, attributes: middleTextAttribute)

        //Image SetUp
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        //End Text SetUp
        let endTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: endTextColor] as [NSAttributedString.Key : Any]
        let endAttributedString = NSAttributedString(string: endText, attributes: endTextAttribute)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(startAttributedString)
        fullString.append(middleAttributedString)
        fullString.append(image1String)
        fullString.append(endAttributedString)
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
    
    func shareWithActivityViewController(VC:UIViewController, shareData: Any) {
        
        var sharingData = [Any]()
        sharingData.append(shareData)
        let activityViewController = UIActivityViewController(activityItems: sharingData, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = VC.view
        VC.present(activityViewController, animated: true, completion: nil)
        printDebug(sharingData)
    }    
}


