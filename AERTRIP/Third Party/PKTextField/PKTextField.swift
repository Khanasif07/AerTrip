//
//  PKTextField.swift
//  PKTextField
//
//  Created by Admin on 01/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

protocol PKTextFieldDelegate: class {
    
    func pkTextFieldDidChanged(_ pkTextField: PKTextField) // on changing text

    func pkTextFieldShouldBeginEditing(_ pkTextField: PKTextField) -> Bool // return NO to disallow editing.
    
    func pkTextFieldDidBeginEditing(_ pkTextField: PKTextField) // became first responder
    
    func pkTextFieldShouldEndEditing(_ pkTextField: PKTextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    
    func pkTextFieldDidEndEditing(_ pkTextField: PKTextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    func pkTextFieldDidEndEditing(_ pkTextField: PKTextField, reason: UITextField.DidEndEditingReason) // if implemented, called in place of textFieldDidEndEditing:
    
    
    func pkTextField(_ pkTextField: PKTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    
    
    func pkTextFieldShouldClear(_ pkTextField: PKTextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    
    func pkTextFieldShouldReturn(_ pkTextField: PKTextField) -> Bool // called when 'return' key pressed. return NO to ignore.
}

extension PKTextFieldDelegate {
    
    func pkTextFieldDidChanged(_ pkTextField: PKTextField) {}

    func pkTextFieldShouldBeginEditing(_ pkTextField: PKTextField) -> Bool { return true }
    
    func pkTextFieldDidBeginEditing(_ pkTextField: PKTextField) {}
    
    func pkTextFieldShouldEndEditing(_ pkTextField: PKTextField) -> Bool { return true }
    
    func pkTextFieldDidEndEditing(_ pkTextField: PKTextField) {}
    
    func pkTextFieldDidEndEditing(_ pkTextField: PKTextField, reason: UITextField.DidEndEditingReason) {}
    
    func pkTextField(_ pkTextField: PKTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return true }
    
    func pkTextFieldShouldClear(_ pkTextField: PKTextField) -> Bool { return true }
    
    func pkTextFieldShouldReturn(_ pkTextField: PKTextField) -> Bool { return true }
}

@IBDesignable
class PKTextField: UIScrollView {
    
    enum ScrollDirection {
        case vertical
        case horizontal
    }
    //MARK:- Properties
    //MARK:- Public
    weak var pkDelegate: PKTextFieldDelegate? = nil
    var scrollDirection = ScrollDirection.horizontal {
        didSet {
            self.updateScrollDirection()
        }
    }
    
    @IBInspectable var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    @IBInspectable var attributedText: NSAttributedString? {
        get {
            return self.textField.attributedText
        }
        set {
            self.textField.attributedText = newValue
        }
    }
    
    @IBInspectable var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    @IBInspectable var attributedPlaceholder: NSAttributedString? {
        get {
            return self.textField.attributedPlaceholder
        }
        set {
            self.textField.attributedPlaceholder = newValue
        }
    }
    
    @IBInspectable var font: UIFont? {
        get {
            return self.textField.font
        }
        set {
            self.textField.font = newValue
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        get {
            return self.textField.textColor
        }
        set {
            self.textField.textColor = newValue
        }
    }
    
    @IBInspectable var textAlignment: NSTextAlignment {
        get {
            return self.textField.textAlignment
        }
        set {
            self.textField.textAlignment = newValue
        }
    }
    
    @IBInspectable var returnKeyType: UIReturnKeyType {
        get {
            return self.textField.returnKeyType
        }
        set {
            self.textField.returnKeyType = newValue
        }
    }
    
    //MARK:- Private
    private let textField: UITextField = UITextField()
    private var oldPanPoint: CGPoint = .zero
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateTextField()
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return self.textField.becomeFirstResponder()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupSubviews() {
        self.textField.isUserInteractionEnabled = true
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
        self.addSubview(self.textField)
        self.clipsToBounds = true
        self.updateTextField()
        self.updateScrollDirection()
        
        self.addTapGesture()
    }
    
    private func addTapGesture() {
        let tapGes = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        self.textField.addGestureRecognizer(tapGes)
    }
    
    @objc private func panHandler(_ sender: UIGestureRecognizer) {
        
        let panPoint = sender.location(in: self)
        if sender.state == .began {
            self.oldPanPoint = panPoint
        }
        else if sender.state == .changed {
            if self.scrollDirection == .vertical {
                let maxY = self.contentSize.height - self.frame.size.height
                let diffY = panPoint.y - self.oldPanPoint.y
                let tempY = (self.contentOffset.y - diffY) + self.contentOffset.y
                
                let finalY = min(max(0, tempY), maxY)
                printDebug("finalY \(finalY)")
                self.setContentOffset(CGPoint(x: 0.0, y: finalY), animated: false)
            }
            else {
                let maxX = self.contentSize.width - self.frame.size.width
                let diffX = panPoint.x - self.oldPanPoint.x
                let tempX = (self.contentOffset.y - diffX) + self.contentOffset.x
                
                let finalX = min(max(0, tempX), maxX)
                printDebug("finalX \(finalX)")
                self.setContentOffset(CGPoint(x: finalX, y: 0.0), animated: false)
            }
        }
    }
    
    private func scrollToEnd() {
        if self.scrollDirection == .vertical {
            if self.textField.frame.size.height > self.frame.size.height {
                let maxY = self.contentSize.height - self.frame.size.height
                self.setContentOffset(CGPoint(x: 0.0, y: maxY), animated: false)
            }
        }
        else {
            if self.textField.frame.size.width > self.frame.size.width {
                let maxX = self.contentSize.width - self.frame.size.width
                self.setContentOffset(CGPoint(x: maxX, y: 0.0), animated: false)
            }
        }
    }
    
    private func updateTextField() {
        
        self.textField.backgroundColor = .clear
        guard let txt = self.text, !txt.isEmpty, let fnt = self.font else {
            self.textField.frame = self.bounds
            return
        }
        
        if self.scrollDirection == .vertical {
            let textSize = self.textSizeCount(forText: txt, font: fnt, bundingSize: CGSize(width: self.frame.size.width, height: 10000.0))
            if textSize.height > self.frame.size.height {
                self.textField.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: textSize.height)
            }
        }
        else {
            let textSize = self.textSizeCount(forText: txt, font: fnt, bundingSize: CGSize(width: 10000.0, height: self.frame.size.height))
            if textSize.width > self.frame.size.width {
                self.textField.frame = CGRect(x: 0.0, y: 0.0, width: textSize.width, height: self.frame.size.height)
            }
        }
        
        self.contentSize = self.textField.frame.size
        self.layoutIfNeeded()
    }
    
    private func updateScrollDirection() {
        self.isScrollEnabled = true
        self.showsVerticalScrollIndicator = self.scrollDirection == .vertical
        self.showsHorizontalScrollIndicator = self.scrollDirection == .horizontal
    }
    
    private func textSizeCount(forText text: String, font: UIFont, bundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: text)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}


extension PKTextField: UITextFieldDelegate {
    
    @objc internal func textFieldDidChanged(_ pkTextField: PKTextField) {
        self.updateTextField()
        self.scrollToEnd()
        self.pkDelegate?.pkTextFieldDidChanged(self)
    }
    
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.pkDelegate?.pkTextFieldShouldBeginEditing(self) ?? true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.pkDelegate?.pkTextFieldDidBeginEditing(self)
    }
    
    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.pkDelegate?.pkTextFieldShouldEndEditing(self) ?? true
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        self.pkDelegate?.pkTextFieldDidEndEditing(self)
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.pkDelegate?.pkTextFieldDidEndEditing(self, reason: reason)
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.pkDelegate?.pkTextField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.pkDelegate?.pkTextFieldShouldClear(self) ?? true
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.pkDelegate?.pkTextFieldShouldReturn(self) ?? true
    }
}




