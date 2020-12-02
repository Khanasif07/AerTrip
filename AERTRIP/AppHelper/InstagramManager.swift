//
//  InstagramManager.swift
//  AERTRIP
//
//  Created by Admin on 17/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

//let documentInteractionController = UIDocumentInteractionController()
class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.photo" //"com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.ig"//"instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application
        
        guard let instagramURL = NSURL(string: kInstagramURL) else {return}
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            
            do {
            try imageInstagram.jpegData(compressionQuality: 0.75)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                printDebug(error)
            }

            let rect = CGRect.zero
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            
            
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
        }
        else {
            
            // alert displayed when the instagram application is not available in the device
            //UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
            AppToast.default.showToastMessage(message: kAlertViewMessage)
        }
    }
}
