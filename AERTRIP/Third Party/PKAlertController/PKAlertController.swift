//
//  PKAlertController.swift
//
//  Created by Pramod Kumar on 16/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

open class PKAlertController {

    //MARK:- Properties
    //MARK:- Public
    static let `default` = PKAlertController()
    
    //MARK:- Private
    private var topMostController: UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
             print("PKAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    private var alertController: UIAlertController!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    private init() {}
    
    //MARK:- Methods
    //MARK:- Private

    
    //MARK:- Public
    func presentActionSheet(_ title: String?, message: String?, sourceView: UIView, alertButtons: [PKAlertButton], cancelButton: PKAlertButton, tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        //add all alert buttons
        let closure: (UIAlertAction) -> Void = { (alert) in
            print(alert.title ?? "")
            if let handel = tapBlock, let idx = alertButtons.firstIndex(where: { (button) -> Bool in
                (alert.title ?? "") == button.title
            }) {
                handel(alert, idx)
            }
        }
        
        for button in alertButtons {
            let alertAction = UIAlertAction(title: button.title, style: .default, handler: closure)
            alertAction.setValue(button.titleColor, forKey: "titleTextColor")
            alertController.addAction(alertAction)
        }
        
        //add cancel button
        let cancelAction = UIAlertAction(title: cancelButton.title, style: .cancel) { (alert) in
            self.dismissActionSheet()
        }
        cancelAction.setValue(cancelButton.titleColor, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        self.topMostController?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    func presentActionSheetWithAttributed(_ title: NSMutableAttributedString?, message: NSMutableAttributedString?, sourceView: UIView, alertButtons: [PKAlertButton], cancelButton: PKAlertButton, tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        
        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alertController.setValue(title, forKey: "attributedTitle")
        alertController.setValue(message, forKey: "attributedMessage")
        
        //add all alert buttons
        let closure: (UIAlertAction) -> Void = { (alert) in
            print(alert.title ?? "")
            if let handel = tapBlock, let idx = alertButtons.firstIndex(where: { (button) -> Bool in
                (alert.title ?? "") == button.title
            }) {
                handel(alert, idx)
            }
        }
        
        for button in alertButtons {
            let alertAction = UIAlertAction(title: button.title, style: .default, handler: closure)
            alertAction.setValue(button.titleColor, forKey: "titleTextColor")
            alertController.addAction(alertAction)
        }
        
        //add cancel button
        let cancelAction = UIAlertAction(title: cancelButton.title, style: .cancel) { (alert) in
            self.dismissActionSheet()
        }
        cancelAction.setValue(cancelButton.titleColor, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        self.topMostController?.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    public func dismissActionSheet() {
        self.alertController.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Action
}
