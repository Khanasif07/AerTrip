//
//  PKTextView.swift
//
//  Created by Pramod Kumar on 11/05/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit

class PKTextView: UITextView {
    
    //MARK:- Internal Properties
    //MARK:-
    fileprivate var shouldDrawPlaceholder = true
    fileprivate var currentFont: UIFont!
    fileprivate var settingOwnText = false
    
    
    //Text view changeable properties
    var placeholder: String = ""
    var attributedPlaceholder : NSMutableAttributedString?
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor = UIColor.darkGray
    var cornerRad: CGFloat = 0.0
    var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

    
    //MARK:- View Initialization
    //MARK:-
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = cornerRad
        self.clipsToBounds = true
        self.currentFont = self.font
        
        //Add Notification for Text View Delegates
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        //Add Observer text key
        self.addObserver(self, forKeyPath: "text", options: [], context: nil)
        self.addObserver(self, forKeyPath: "font", options: [], context: nil)
    }
    
    deinit {
        
        //Remove Notification for Text View Delegates
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        //Remove Observer text key
        self.removeObserver(self, forKeyPath: "text", context: nil)
        self.removeObserver(self, forKeyPath: "font", context: nil)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        self.font = self.currentFont
        if self.shouldDrawPlaceholder {
            let finalRect = CGRect(x: self.placeholderInsets.left,y: self.placeholderInsets.top,width: self.frame.size.width-(self.placeholderInsets.left + self.placeholderInsets.right),height: self.frame.size.height-(self.placeholderInsets.top+self.placeholderInsets.bottom))
            if let plceText = self.attributedPlaceholder {
                plceText.draw(in: finalRect)
            }
            else {
                self.placeholder.draw(in: finalRect, withAttributes: [NSAttributedString.Key.font : self.currentFont, NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }
        }
    }
    
    @objc func textDidChange(_ sender : Foundation.Notification) {
        
        self.font = self.currentFont
        self.shouldDrawPlaceholder = self.text.count <= 0 ? true : false
        self.setNeedsDisplay()
    }
    
    //MARK:- Observer method for registered keys
    //MARK:-
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "text") && (!self.settingOwnText) && (object as AnyObject).isKind(of: PKTextView.self) {
            self.shouldDrawPlaceholder = self.text.count <= 0 ? true : false
            self.setNeedsDisplay()
        }
        if keyPath == "font" && (object as AnyObject).isKind(of: PKTextView.self) {
            self.currentFont = self.font
        }
    }
}

// Prevent entering multiple spaces
extension PKTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: .whitespacesAndNewlines).location != 0
    }
}
