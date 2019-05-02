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
  // print(obj)
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

func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return ((lhs.longitude == rhs.longitude) && (lhs.latitude == rhs.latitude))
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
    
    func object(from json:String) -> Any? {
        
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
    
    func getImageFor(firstName: String?, lastName: String?, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12) , backGroundColor: UIColor = AppColors.themeWhite) -> UIImage {
        
        let string = "\((firstName ?? "F").firstCharacter)\((lastName ?? "L").firstCharacter)".uppercased()
        return self.getImageFromText(string, font: font, textColor: textColor, offSet: offSet , backGroundColor: backGroundColor)
    }
    
    func getImageFromText(_ fromText: String, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12) , backGroundColor: UIColor = AppColors.themeWhite) -> UIImage {
        let size = 70.0
        return UIImage(text: fromText, font: font, color: textColor, backgroundColor: backGroundColor, size: CGSize(width: size, height: size), offset: offSet)!
    }
    
    func showErrorOnToastView(withErrors errors: ErrorCodes, fromModule module: ATErrorManager.Module) {
        
        let (_, message, _) = ATErrorManager.default.error(forCodes: errors, module: module)
        if !message.isEmpty {
            AppToast.default.showToastMessage(message: message)
        }
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
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        VC.present(activityViewController, animated: true, completion: nil)
        printDebug(sharingData)
    }
    
    ///GET TEXT SIZE
    func getTextWidthAndHeight(text: String , fontName: UIFont) -> CGSize{
        let fontAttributes = [NSAttributedString.Key.font: fontName]
        let sizeOfText = text.size(withAttributes: fontAttributes)
        return sizeOfText
    }
    
    func addBlurEffect(forView: UIView) {
        forView.insertSubview(getBlurView(forView: forView), at: 0)
        forView.backgroundColor = AppColors.clear
        
        forView.insertSubview(getBlurView(forView: forView), at: 0)
        forView.backgroundColor = AppColors.clear
    }
    
    func getBlurView(forView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = forView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func createParagraphAttribute(paragraphSpacingBefore: CGFloat = -8.0) -> NSParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
        paragraphStyle.minimumLineHeight = 0
        paragraphStyle.maximumLineHeight = 0
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        paragraphStyle.paragraphSpacing = paragraphStyle.paragraphSpacingBefore + 0.0
        return paragraphStyle
    }
    
    
    private func openGoogleMaps(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string:
                "comgooglemaps://?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)&directionsmode=driving&zoom=14&views=traffic"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            AppToast.default.showToastMessage(message: "Google Maps is not installed on your device.")
        }
    }
    
    private func openAppleMap(originLat: String ,originLong:String ,destLat: String ,destLong:String) {
        let directionsURL = "http://maps.apple.com/?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)"
        if let url = URL(string: directionsURL), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Can't use apple map://")
        }
    }
    
    func redirectToMap(sourceView: UIView , originLat: String, originLong: String, destLat: String, destLong: String) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized,LocalizedString.GMap.localized], colors: [AppColors.themeGreen,AppColors.themeGreen])
        let titleFont = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
        let titleAttrString = NSMutableAttributedString(string: LocalizedString.Choose_App.localized, attributes: titleFont)
        
        _ = PKAlertController.default.presentActionSheetWithAttributed(nil, message: titleAttrString, sourceView: sourceView, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                self.openAppleMap(originLat: originLat, originLong: originLong, destLat: destLat, destLong: destLong)
            } else {
                self.openGoogleMaps(originLat: originLat, originLong: originLong, destLat: destLat, destLong: destLong)
            }
        }
    }
    
//    func nativePopUp(vc: UIViewController) {
//        let actionSheetAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
////        actionSheetAlertController.addAction(cancelActionButton)
//        
//        let documentsActionButton = UIAlertAction(title: "Documents", style: .default, handler: nil)
//        actionSheetAlertController.addAction(documentsActionButton)
//        documentsActionButton.setValue(#imageLiteral(resourceName: "checkIcon"), forKey: "image")
//        documentsActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        
//        let cameraActionButton = UIAlertAction(title: "Camera", style: .default, handler: nil)
//        actionSheetAlertController.addAction(cameraActionButton)
//        cameraActionButton.setValue(#imageLiteral(resourceName: "checkIcon"), forKey: "image")
//        cameraActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        
//        let galleryActionButton = UIAlertAction(title: "Gallery", style: .default, handler: nil)
//        actionSheetAlertController.addAction(galleryActionButton)
//        galleryActionButton.setValue(#imageLiteral(resourceName: "checkIcon"), forKey: "image")
//        galleryActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
//        
//        
//        actionSheetAlertController.view.tintColor = AppColors.themeWhite.withAlphaComponent(0.85)
//        vc.present(actionSheetAlertController, animated: true, completion: nil)
//    }
}


