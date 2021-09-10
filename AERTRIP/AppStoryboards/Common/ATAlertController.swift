//
//  AlertController.swift
//  AlertController
//
//  Created by Anupam Katiyar on 14/01/16.
//  Copyright © 2015 Anupam Katiyar. All rights reserved.
//

import UIKit

public class ATAlertController {
    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================
    
    class var instance : ATAlertController {
        struct Static {
            static let inst = ATAlertController()
        }
        return Static.inst
    }
    
    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================
    
    private func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            printDebug("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    
    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
//    public class func alert(title: String) -> UIAlertController {
//        return alert(title: title, message: "")
//    }
    
//    public class func alert(title: String, message: String) -> UIAlertController {
//        return alert(title, message: message, acceptMessage: "OK") { () -> () in
//            // Do nothing
//        }
//    }
    
    public class func alert(vc : UIViewController ,title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func alert(vc : UIViewController , title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    public class func alertOnVC(title: String, message: String,vcObj : UIViewController, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        vcObj.present(alert, animated: true, completion: nil)
        
        //sharedAppdelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)

        
        return alert
    }
    
    public class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        
        guard let controler = ATAlertController.instance.topMostController() else { return alert}
        controler.present(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func actionSheet(vc : UIViewController ,title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func actionSheet(vc : UIViewController , title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        vc.present(alert, animated: true, completion: nil)
        return alert
    }
}

private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
    
    self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
       
        }
    }
    
}
