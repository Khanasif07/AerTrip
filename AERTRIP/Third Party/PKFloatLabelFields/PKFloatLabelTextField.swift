//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Pramod Kumar on 28/10/15.
//  Copyright © 2015 Pramod Kumar. All rights reserved.
//


import UIKit

@IBDesignable class PKFloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var title = UILabel()

    // MARK: View components
    
    /// The internal `UIView` to display the line below the text input.
    open var lineView = UIView()
    
    var isHiddenBottomLine: Bool = false {
        didSet {
            updateLineView()
        }
    }
    
    var isFloatingField: Bool = true {
        didSet  {
            self.hideTitle(true)
        }
    }
    
    var lineViewBottomSpace: CGFloat = -3.0 {
        didSet  {
            self.updateLineView()
        }
    }
    
    var isSingleTextField: Bool = true {
        didSet {
            self.updateLineView()
        }
    }
    
    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }
    
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable dynamic open var lineColor: UIColor = AppColors.divider.color {
        didSet {
            updateLineView()
        }
    }
    
    /// A UIColor value that determines the color of the bottom line when in the normal state
    @IBInspectable dynamic open var selectedLineColor: UIColor = AppColors.divider.color {
        didSet {
            updateLineView()
        }
    }
    
    @IBInspectable dynamic open var lineErrorColor: UIColor = AppColors.divider.color
    
    // MARK: Line height
    
    /// A CGFloat value that determines the height for the bottom line when the control is in the normal state
    @IBInspectable dynamic open var lineHeight: CGFloat = 0.5 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }
    
    /// A CGFloat value that determines the height for the bottom line when the control is in a selected state
    @IBInspectable dynamic open var selectedLineHeight: CGFloat = 0.5 {
        didSet {
            updateLineView()
            setNeedsDisplay()
        }
    }
    
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if let txt = text , txt.isEmpty {
				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	
	override var placeholder:String? {
		didSet {
			title.text = placeholder
			title.sizeToFit()
		}
	}
	
	override var attributedPlaceholder:NSAttributedString? {
		didSet {
			title.text = attributedPlaceholder?.string
			title.sizeToFit()
		}
	}
	
	var titleFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
		didSet {
			title.font = titleFont
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour: UIColor = UIColor.gray {
		didSet {
			if !isFirstResponder {
				title.textColor = titleTextColour
			}
		}
	}
	
	@IBInspectable var titleActiveTextColour: UIColor! {
		didSet {
			if isFirstResponder {
				title.textColor = titleActiveTextColour
			}
		}
	}
    
    @IBInspectable var titleErrorTextColour: UIColor = AppColors.themeRed
    
    var isSelectionOptionEnabled: Bool = true
    
    var isError: Bool = false{
        didSet {
            self.layoutSubviews()
        }
    }
		
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setupSubviews()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setupSubviews()
	}
	
	// MARK:- Overrides
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.isSelectionOptionEnabled {
            return super.canPerformAction(action, withSender: sender)
        }
        else {
            return false
        }
    }
    
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
        
        let isResp = isFirstResponder
        if self.isError {
            self.title.textColor = self.titleErrorTextColour
            self.lineView.backgroundColor = self.lineErrorColor
        }
        else {
            if let txt = text , !txt.isEmpty && isResp {
                title.textColor = titleActiveTextColour
                lineView.backgroundColor = selectedLineColor
            } else {
                title.textColor = titleTextColour
                lineView.backgroundColor = lineColor
            }
        }
		// Should we show or hide the title label?
		if let txt = text , txt.isEmpty {
			// Hide
            if isFloatingField {
               hideTitle(isResp)
            }
			
		} else {
			// Show
            if isFloatingField {
                showTitle(isResp)
            }
			
		}
        
        autocapitalizationType = (keyboardType == .emailAddress) ? .none : .sentences
	}
	
	override func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if let txt = text , !txt.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
            r = r.inset(by: UIEdgeInsets(top: top, left: 0.0, bottom: 0.0, right: 0.0))
		}
		return r.integral
	}
	
	override func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
       
		if let txt = text , !txt.isEmpty {
            updateLineView(isEditing: true)
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
            r = r.inset(by: UIEdgeInsets(top: top, left: 0.0, bottom: 4.0, right: 0.0))
        } else {
            UIView.animate(withDuration: 0.0) { [weak self] in
                self?.updateLineView(isEditing: false)
            }
          
        }
		return r.integral
	}
	
	override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if let txt = text , !txt.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	fileprivate func setupSubviews() {
        
        borderStyle = UITextField.BorderStyle.none
		titleActiveTextColour = tintColor
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		if let str = placeholder , !str.isEmpty {
			title.text = str.uppercased()
			title.sizeToFit()
		}
        
        self.createLineView()
        
		self.addSubview(title)
        
        self.addTarget(self, action: #selector(self.textDidBeginEditing), for: .editingDidBegin)
	}
    
    @objc func textDidBeginEditing() {
        //set the appropriate state while editing
        self.isError = false
    }
    
	fileprivate func maxTopInset()->CGFloat {
		if let fnt = font {
			return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
		}
		return 0
	}
	
	fileprivate func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		var x = r.origin.x
		if textAlignment == NSTextAlignment.center {
			x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
		} else if textAlignment == NSTextAlignment.right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
	}

	fileprivate func showTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseOut], animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			}, completion:nil)
	}
	
	fileprivate func hideTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
    
    fileprivate func createLineView() {
        
        lineView.isUserInteractionEnabled = false
        
        updateLineView()
        setNeedsDisplay()
        
        lineView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(lineView)
    }
    
    fileprivate func updateLineView(isEditing: Bool = false) {
        lineView.isHidden = self.isHiddenBottomLine
        lineView.frame = lineViewRectForBounds(bounds, editing: editingOrSelected,isEditing: isEditing)
        lineView.backgroundColor = self.lineColor
    }
    

    /**
     Calculate the bounds for the bottom line of the control.
     Override to create a custom size bottom line in the textbox.
     - parameter bounds: The current bounds of the line
     - parameter editing: True if the control is selected or highlighted
     - returns: The rectangle that the line bar should render in
     */
    fileprivate func lineViewRectForBounds(_ bounds: CGRect, editing: Bool,isEditing: Bool = false) -> CGRect {
        let height = editing ? selectedLineHeight : lineHeight
        return CGRect(x: 0, y: bounds.size.height - height - (isEditing ? (self.isSingleTextField ? -3.0 :  self.lineViewBottomSpace) : self.lineViewBottomSpace), width: bounds.size.width, height: height)
    }

    
    
    
}

extension PKFloatLabelTextField {
    
    func setupTextField(placehoder: String,with symbol: String = "",foregroundColor: UIColor = AppColors.themeGray40,
                        textColor: UIColor = AppColors.themeBlack,
                        titleTextColor: UIColor = AppColors.themeGray20,
                        titleFont: UIFont = AppFonts.Regular.withSize(14.0),
                        titleActiveTextColor: UIColor = AppColors.themeGreen,
                        keyboardType: UIKeyboardType,
                        returnType: UIReturnKeyType,
                        isSecureText: Bool) {
        
        self.keyboardType       = keyboardType
        self.placeholder        = placehoder
        self.textColor          = textColor
        self.isSecureTextEntry  = isSecureText
        self.returnKeyType      = returnType
        self.font           = AppFonts.Regular.withSize(18)
        self.tintColor = AppColors.themeGreen
        self.titleTextColour = titleTextColor
        self.titleFont = titleFont
        self.titleActiveTextColour = titleActiveTextColor
        let attriburedString = NSMutableAttributedString(string: placehoder)
        let asterix = NSAttributedString(string: symbol, attributes: [.foregroundColor: foregroundColor])
        attriburedString.append(asterix)
        
        self.attributedPlaceholder = attriburedString
    }
    
    
    
}
