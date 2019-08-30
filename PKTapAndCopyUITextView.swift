//
//  PKTapAndCopyUITextView.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
@IBDesignable
class PKTapAndCopyUITextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        gestureRecognizer.minimumPressDuration = 0.3
        self.addGestureRecognizer(gestureRecognizer)
        self.isUserInteractionEnabled = true
        self.tintColor = UIColor.clear
    }
    
    // MARK: - UIGestureRecognizer
    @objc func handleLongPressGesture(_ recognizer: UIGestureRecognizer) {
        guard recognizer.state == .recognized else { return }
        
        if let recognizerView = recognizer.view,
            let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder()
        {
            let menuController = UIMenuController.shared
            menuController.setTargetRect(recognizerView.frame, in: recognizerSuperView)
            menuController.setMenuVisible(true, animated:true)
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(UIResponderStandardEditActions.copy(_:)))
        
    }
    // MARK: - UIResponderStandardEditActions
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    

}
