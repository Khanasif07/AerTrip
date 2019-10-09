//
//  Globals.swift
//
//
//  Created by Pramod Kumar on 09/03/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import IQKeyboardManager
import MapKit
import PKLoader
import UIKit
import EventKit

func printDebug<T>(_ obj: T) {
     print(obj)
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func printFonts() {
    for family in UIFont.familyNames {
        let fontsName = UIFont.fontNames(forFamilyName: family)
        printDebug(fontsName)
    }
}


func delay(seconds: Double, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return ((lhs.longitude == rhs.longitude) && (lhs.latitude == rhs.latitude))
}

class AppGlobals {
    static let shared = AppGlobals()
    private init() {}
    
    
    //vcs used in mybooking filter screen
    var travelDateVC: TravelDateVC?
    var eventTypeVC: EventTypeVC?
    var bookingDateVC: TravelDateVC?
    
    static func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight / charSize
        return lineCount
    }
    
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func object(from json: String) -> Any? {
        if let data = json.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
        }
        return nil
    }
    
    static func retunsStringArray(jsonArr: [JSON]) -> [String] {
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
    
    func getImageFor(firstName: String?, lastName: String?, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12), backGroundColor: UIColor = AppColors.themeWhite) -> UIImage {
        var fName = firstName ?? ""
        var lName = lastName ?? ""
        
        if fName.isEmpty, lName.isEmpty {
            fName = "F"
            lName = "L"
        } else if !fName.isEmpty, lName.isEmpty {
            lName = ""
        } else if fName.isEmpty, !lName.isEmpty {
            fName = ""
        }
        
        let string = "\(fName.firstCharacter)\(lName.firstCharacter)".uppercased()
        return self.getImageFromText(string, font: font, textColor: textColor, offSet: offSet, backGroundColor: backGroundColor)
    }
    
    func getImageFromText(_ fromText: String, font: UIFont = AppFonts.Regular.withSize(40.0), textColor: UIColor = AppColors.themeGray40, offSet: CGPoint = CGPoint(x: 0, y: 12), backGroundColor: UIColor = AppColors.themeWhite) -> UIImage {
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
    
    func formattedDateFromString(dateString: String, inputFormat iF: String, withFormat outputFormat: String) -> String? {
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
            temp.append(PKAlertButton(title: title, titleColor: colors[idx],titleFont: AppFonts.Regular.withSize(20.0)))
        }
        
        return temp
    }
    
    var pKAlertCancelButton: PKAlertButton {
        return PKAlertButton(title: LocalizedString.Cancel.localized, titleColor: AppColors.themeDarkGreen)
    }
    
    func saveImage(data: Data, fileNameWithExtension: String? = nil) -> String {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = fileNameWithExtension ?? "\(UIDevice.uuidString).jpg"
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
    
    func saveFileToDocument(fromUrl: URL) -> String {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = fromUrl.lastPathComponent
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        
        FileManager.removeFile(atPath: fileURL.path)
        do {
            // copy item
            try FileManager.default.moveItem(at: fromUrl, to: fileURL)
            printDebug("copy saved")
            return fileURL.path
        } catch {
            printDebug("error copying file:")
            return ""
        }
    }
    
    // Use  it for creating an image with text .It will return NSMutableattributed string.
    func getTextWithImage(startText: String, image: UIImage, endText: String, font: UIFont, isEndTextBold: Bool = false) -> NSMutableAttributedString {
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
        if isEndTextBold {
            let endStringAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key: Any]
            let endAttributedString = NSAttributedString(string: "   " + endText, attributes: endStringAttribute)
            fullString.append(endAttributedString)
        } else {
            fullString.append(NSAttributedString(string: endText))
        }
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
    // Use  it for creating an image with text(attributed string )  .It will return NSMutableattributed string.
    func getTextWithImage(startText: String, image: UIImage, endText: NSMutableAttributedString, font: UIFont) -> NSMutableAttributedString {
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
        fullString.append(NSMutableAttributedString(string: "  "))
        fullString.append(endText)
        return fullString
    }
    
    func getTextWithImageWithLink(startText: String, startTextColor: UIColor, middleText: String, image: UIImage, endText: String, endTextColor: UIColor, middleTextColor: UIColor, font: UIFont) -> NSMutableAttributedString {
        let fullString = NSMutableAttributedString()
        
        //Start Text SetUp
        let startTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: startTextColor] as [NSAttributedString.Key: Any]
        let startAttributedString = NSAttributedString(string: startText, attributes: startTextAttribute)
        
        //Middle Text SetUp
        let middleTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: middleTextColor] as [NSAttributedString.Key: Any]
        let middleAttributedString = NSAttributedString(string: middleText, attributes: middleTextAttribute)
        
        //Image SetUp
        let image1Attachment = NSTextAttachment()
        image1Attachment.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        image1Attachment.image = image
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        //End Text SetUp
        let endTextAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: endTextColor] as [NSAttributedString.Key: Any]
        let endAttributedString = NSAttributedString(string: endText, attributes: endTextAttribute)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(startAttributedString)
        fullString.append(middleAttributedString)
        fullString.append(image1String)
        fullString.append(endAttributedString)
        fullString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: fullString.length))
        
        return fullString
    }
    
    func shareWithActivityViewController(VC: UIViewController, shareData: Any) {
        var sharingData = [Any]()
        sharingData.append(shareData)
        let activityViewController = UIActivityViewController(activityItems: sharingData, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = VC.view
        UIApplication.shared.keyWindow?.tintColor = AppColors.themeGreen
        VC.present(activityViewController, animated: true, completion: nil)
        printDebug(sharingData)
    }
    
    ///GET TEXT SIZE
    func getTextWidthAndHeight(text: String, fontName: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: fontName]
        let sizeOfText = text.size(withAttributes: fontAttributes)
        return sizeOfText
    }
    
    func addBlurEffect(forView: UIView) {
        forView.insertSubview(self.getBlurView(forView: forView), at: 0)
        forView.backgroundColor = AppColors.clear
        
        forView.insertSubview(self.getBlurView(forView: forView), at: 0)
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
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey: Any])]
        paragraphStyle.minimumLineHeight = 0
        paragraphStyle.maximumLineHeight = 0
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        paragraphStyle.paragraphSpacing = paragraphStyle.paragraphSpacingBefore + 0.0
        return paragraphStyle
    }
    
    func openGoogleMaps(originLat: String, originLong: String, destLat: String, destLong: String) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            //to show the route between source and destination uncomment the next line
            let urlStr = "comgooglemaps://?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)&directionsmode=driving&zoom=14&views=traffic"
            
//            let urlStr = "comgooglemaps://?center=\(destLat),\(destLong)&zoom=14&views=traffic"
            
            if let url = URL(string: urlStr), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            AppToast.default.showToastMessage(message: "Google Maps is not installed on your device.")
        }
    }
    
    func openAppleMap(originLat: String, originLong: String, destLat: String, destLong: String) {
        //        let directionsURL = "http://maps.apple.com/?\(destLat),\(destLong)"
        //to show the route between source and destination uncomment the next line
        
        var directionURL = ""
        if originLat.isEmpty && originLong.isEmpty {
            directionURL = "http://maps.apple.com/?daddr=\(destLat),\(destLong)"
        } else {
            directionURL = "http://maps.apple.com/?saddr=\(originLat),\(originLong)&daddr=\(destLat),\(destLong)"
        }
        
        
        
        if let url = URL(string: directionURL), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            printDebug("Can't use apple map://")
        }
        
        //        let latitute:CLLocationDegrees = originLat.toDouble ?? 0.0
        //        let longitute:CLLocationDegrees = originLong.toDouble ?? 0.0
        //
        //        let regionDistance:CLLocationDistance = 10000
        //        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        //        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        //        let options = [
        //            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        //            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        //        ]
        //        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        //        let mapItem = MKMapItem(placemark: placemark)
        //        mapItem.name = ""
        //        mapItem.openInMaps(launchOptions: options)
    }
    
    func redirectToMap(sourceView: UIView, originLat: String, originLong: String, destLat: String, destLong: String) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Maps.localized, LocalizedString.GMap.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
//        let titleFont = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40]
//        let titleAttrString = NSMutableAttributedString(string: LocalizedString.Choose_App.localized, attributes: titleFont)
        _ = PKAlertController.default.presentActionSheet(LocalizedString.Choose_App.localized, titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, message: nil, messageFont: nil, messageColor: nil, sourceView: sourceView, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: { [weak self] _, index in
            if index == 0 {
                self?.openAppleMap(originLat: originLat, originLong: originLong, destLat: destLat, destLong: destLong)
            } else if index == 1 {
                self?.openGoogleMaps(originLat: originLat, originLong: originLong, destLat: destLat, destLong: destLong)
            }
        })
    }
    

    func addEventToCalender(title: String, startDate: Date, endDate: Date, notes: String = "", uniqueId: String = "") {
        
        let eventStore = EKEventStore()
        func addToCalendar() {
            eventStore.requestAccess(to: EKEntityType.event, completion: { granted, error in
                
                if granted, (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = notes
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    DispatchQueue.mainAsync {
                        do {
                            try eventStore.save(event, span: .thisEvent)
                            AppToast.default.showToastMessage(message: LocalizedString.EventAddedToCalander.localized)
                        } catch let error as NSError {
                            AppToast.default.showToastMessage(message: LocalizedString.UnableToAddEventToCalander.localized)
                            print("json error: \(error.localizedDescription)")
                        }
                    }
                }
            })
        }
        
        let authorization = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if authorization == .authorized || authorization == .notDetermined {
            
            if uniqueId.isEmpty {
                addToCalendar()
            }
            else {
                var isAdded: Bool = false
                
                //logic for isAdded
                let pred = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                for event in eventStore.events(matching: pred) {
                    if event.title.contains(uniqueId) {
                        isAdded = true
                        break
                    }
                }
                
                if isAdded {
                    AppToast.default.showToastMessage(message: LocalizedString.EventAlreadyAddedInCalendar.localized)
                }
                else {
                    addToCalendar()
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "", message: "You have been restricted from using the calendar on this device without calendar access this feature wont work.", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionSettings = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                UIApplication.openSettingsApp
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
            }
            alertController.addAction(alertActionSettings)
            alertController.addAction(alertActionCancel)
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
        
    //MARK: - Get Strike Through text from a Strig
    
    func getStrikeThroughText(str: String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func showUnderDevelopment() {
        AppToast.default.showToastMessage(message: LocalizedString.UnderDevelopment.localized)
    }
    
    
    func isNetworkRechable() -> Bool {
        let rechability = Reachability.networkReachabilityForInternetConnection()
        return  rechability?.isReachable ?? false
    }
}

//MARK: - Project Used Extensions

extension Double {
    var amountInDelimeterWithSymbol: String {
        if self < 0 {
            return "- \(abs(self.roundTo(places: 0)).delimiterWithSymbolTill2Places)"
        } else {
            return "\(self.roundTo(places: 0).delimiterWithSymbolTill2Places)"
        }
    }
    
    var amountInDoubleWithSymbol: String {
        if self < 0 {
            return "- \(abs(self.roundTo(places: 0)))"
        } else {
            return "\(self.roundTo(places: 0))"
        }
    }
    
    var amountInIntWithSymbol: String {
        if self < 0 {
            return "- \(abs(Int(self)))"
        } else {
            return "\(Int(self))"
        }
    }
}

extension AppGlobals {
     func startLoading(animatingView: UIView? = nil,loaderBgColor: UIColor = AppColors.themeWhite) {
        PKLoaderSettings.shared.indicatorColor =  AppColors.themeGreen
        PKLoaderSettings.shared.indicatorType = .activityIndicator
        PKLoaderSettings.shared.backgroundColor = loaderBgColor
        PKLoader.shared.startAnimating(onView: animatingView)
    }
    
    func stopLoading() {
        PKLoader.shared.stopAnimating()
    }
    
    private func downloadPdf(fileURL: URL, screenTitle: String, complition: @escaping ((URL?) -> Void)) {
        // Create destination URL
        if let documentsUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let destinationFileUrl = documentsUrl.appendingPathComponent("\(screenTitle).pdf")
            
            if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                try? FileManager.default.removeItem(at: destinationFileUrl)
            }
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let request = URLRequest(url: fileURL)
            
            let task = session.downloadTask(with: request) { tempLocalUrl, response, error in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        printDebug("Successfully downloaded. Status code: \(statusCode)")
                    }
                    
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        complition(destinationFileUrl)
                    } catch let writeError {
                        printDebug("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                } else {
                    printDebug("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "N/A")")
                }
            }
            task.resume()
        } else {
            complition(nil)
        }
    }
    
    func viewPdf(urlPath: String, screenTitle: String) {
        //open pdf for booking id
        
        guard AppNetworking.isConnectedToNetwork else {
            AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
            return
        }
        
        guard let url = urlPath.toUrl else {
            printDebug("Please pass valid url")
            return
        }
        
        AppGlobals.shared.startLoading()
        self.downloadPdf(fileURL: url, screenTitle: screenTitle) { localPdf in
            if let url = localPdf {
               
                DispatchQueue.mainSync {
                    AppGlobals.shared.stopLoading()
                    AppFlowManager.default.openDocument(atURL: url, screenTitle: screenTitle)
                }
            }
        }
    }
    
    func getAirlineCodeImageUrl(code: String) -> String {
        return "https://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/\(code.uppercased()).png"
    }
    
    func getBlurView(forView: UIView, isDark: Bool) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: isDark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = forView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
     func removeBlur(fromView: UIView) {
        for vw in fromView.subviews {
            if vw.isKind(of: UIVisualEffectView.self) {
                vw.removeFromSuperview()
                break
            }
        }
    }
}

/*extension AppGlobals {
 
    enum DocumentType {
        case others , flights , hotels
    }
 
    func checkCreateAndReturnDocumentFolder(currentDocumentType: DocumentType) -> String {
        let fileManager = FileManager.default
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
        switch currentDocumentType {
        case .others:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("others").path) {
                return documentDirectory.appendingPathComponent("others").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("others").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("others").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        case .flights:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("flights").path) {
                return documentDirectory.appendingPathComponent("flights").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("flights").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("flights").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        case .hotels:
            if self.directoryExistsAtPath(documentDirectory.appendingPathComponent("/hotels").path) {
                return documentDirectory.appendingPathComponent("hotels").path
            } else {
                do {
                    try fileManager.createDirectory(atPath: documentDirectory.appendingPathComponent("hotels").path, withIntermediateDirectories: true, attributes: nil)
                    return documentDirectory.appendingPathComponent("hotels").path
                }
                catch let error as NSError {
                    printDebug("Ooops! Something went wrong: \(error)")
                    return ""
                }
            }
        }
    }
 
    func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
 
    func checkIsFileExist(nameOfFile: String ,path: String) -> Bool {
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(nameOfFile) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                printDebug("FILE AVAILABLE")
                return true
            } else {
                printDebug("FILE NOT AVAILABLE")
                return false
            }
        } else {
            printDebug("FILE PATH NOT AVAILABLE")
            return false
        }
    }
}
*/


// MARK: - New Salutation Change

extension AppGlobals {
    func getEmojiIcon(dob: String,salutation: String,dateFormatter: String) -> UIImage {
        var emoji = UIImage(named: "person")
        var age = -1
        var year = false
        let dd = dob.toDate(dateFormat: dateFormatter) ?? Date()
            age = dd.age
            year = true;
            if (age == 0) {
                year = false;
                age = Date().monthsFrom(dd)
            }
        switch (salutation) {
        case "Mr","Mr.", "Mast","Mast.":
        if (age == -1) {
        emoji = UIImage(named: "man")
        } else {
            if (year) {
                if (age > 12) {
                    emoji = UIImage(named: "man")
                } else if (age > 2) {
                    emoji = UIImage(named: "boy")
                }else {
                    emoji = UIImage(named: "infant")
                }
            } else {
                emoji = UIImage(named: "infant")
            }
            }
        case "Mrs","Mrs.","Ms","Ms.","Miss","Miss.":
            if (age == -1) {
                emoji = UIImage(named: "woman")
            } else {
                if (year) {
                    if (age > 12) {
                        emoji = UIImage(named: "woman")
                    } else if (age > 2) {
                        emoji = UIImage(named: "girl")
                    }else {
                        emoji = UIImage(named: "infant")
                    }
                } else {
                    emoji = UIImage(named: "infant")
                }
            }
        default:
        emoji = UIImage(named: "person")
        }
        return emoji!
    }
    
    //get Age Last String Based on DOB
    func  getAgeLastString(dob : String,formatter: String) -> String {
        var ageString = "";
        let dateDob: Date = dob.toDate(dateFormat: formatter) ?? Date()
        printDebug(dateDob)
        let years = Date().yearsFrom(dateDob)
        if (years == 0) {
            let months = Date().monthsFrom(dateDob)
            if (months == 0) {
                let days = Date().daysFrom(dateDob)
                if days != 0 {
                    ageString = "(" + (days.toString) + "d)"
                }
            } else {
                ageString = "(" + (months.toString) + "m)"
            }
        } else {
            ageString = "(" + (years.toString ) + "y)"
        }
        
        return " " + ageString
    }
    // Get: Salutation based on  geneder and age
    func getSalutationAsPerGenderAndAge(gender: String, dob : String,dateFormatter: String) -> String {
        var mGender =  gender
       let dd = dob.toDate(dateFormat: dateFormatter) ?? Date()
       let age = dd.age
        if (age != 0) {
            switch (mGender) {
            case "Mr","Mast":
                if (age > 12) {
                    mGender = "Mr";
                }
                else if (age > 2) {
                    mGender = "Mast";
                }
                else {
                    mGender = "Mast";
                }
            case "Ms","Mrs","Miss":
                if (age > 12) {
                    mGender = "Ms";
                }
                else if (age > 2) {
                    mGender = "Miss";
                }
                else {
                    mGender = "Miss"
                    
                }
            default:
                mGender = "Mr"
            }
        }
      return mGender;
        
    }
}



