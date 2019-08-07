//
//  ATSwitcher.swift
//  SwitcherExample
//
//  Created by apple on 19/02/19.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ATSwitcherChangeValueDelegate: class {
    func switcherDidChangeValue(switcher: ATSwitcher,value: Bool)
}

class ATSwitcher: UIView {

    var button: UIButton!
    weak var delegate: ATSwitcherChangeValueDelegate?
    
    @IBInspectable var on: Bool = false
    
    @IBInspectable var originalImage:UIImage?{
        didSet {
            button.setImage(originalImage, for: .normal)
        }
    }
    
    @IBInspectable var selectedImage:UIImage?{
        didSet {
            button.setImage(selectedImage, for: .selected)
        }
    }
    
    @IBInspectable var selectedColor:UIColor = UIColor.green
    @IBInspectable var originalColor:UIColor = UIColor.gray
    @IBInspectable var selectedBorderColor:UIColor = UIColor.clear
    @IBInspectable var originalBorderColor:UIColor = UIColor.lightGray
    @IBInspectable var selectedBorderWidth:CGFloat = 0.0
    @IBInspectable var originalBorderWidth:CGFloat = 1.5
    @IBInspectable var iconPadding:CGFloat = 3.0
    
    @IBInspectable var iconBorderWidth:CGFloat = 1.0 {
        didSet {
            button.layer.borderWidth = iconBorderWidth
        }
    }
    
    @IBInspectable var iconBorderColor:UIColor = UIColor.lightGray {
        didSet {
            button.layer.borderColor = iconBorderColor.cgColor
        }
    }
    
     init(frame: CGRect, on: Bool) {
        super.init(frame: frame)
        self.on = on
        commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        button = UIButton(type: .custom)
        button.frame = self.imageButtonFrame
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControl.Event.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.backgroundColor = originalColor
        
        //add a tap gesture on full switch button, so that it'll be easy to tap.
        button.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switcherButtonTouch(_:)))
        self.addGestureRecognizer(tapGesture)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowPath  = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.bounds.height / 2).cgPath
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 2.0
        
        if on == true {
            self.backgroundColor = selectedColor
        } else {
            self.backgroundColor = originalColor
        }
        
        button.frame = self.imageButtonFrame
        animationSwitcherButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private var imageButtonFrame: CGRect {
        let iconH = (self.frame.height - (iconPadding * 2.0))
        let switchWidth = (self.frame.width - (iconPadding * 2.0))
        return CGRect(x: iconPadding + (on ? (switchWidth - iconH) : 0.0 ), y: iconPadding, width: iconH, height: iconH)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switcherButtonTouch(_ sender: UIGestureRecognizer) {
        on = !on
        animationSwitcherButton()
        delegate?.switcherDidChangeValue(switcher: self, value: on)
    }
    
    func setOn(isOn: Bool, animated: Bool = true, shouldNotify: Bool = true) {
        on = isOn
        animationSwitcherButton(animated: animated)
        if shouldNotify {
            delegate?.switcherDidChangeValue(switcher: self, value: on)
        }
    }
    
    func animationSwitcherButton(animated: Bool = true) {
        button.backgroundColor = originalColor
        if on == true {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = true
                
                self.button.frame = self.imageButtonFrame
                
                self.layer.borderColor = self.selectedBorderColor.cgColor
                self.layer.borderWidth = self.selectedBorderWidth
                
                self.backgroundColor = self.selectedColor
                
                self.layoutIfNeeded()
                }, completion: { (finish:Bool) -> Void in
            })
        } else {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = false
                
                self.button.frame = self.imageButtonFrame

                self.layer.borderColor = self.originalBorderColor.cgColor
                self.layer.borderWidth = self.originalBorderWidth
                
                self.backgroundColor = self.originalColor

                self.layoutIfNeeded()
                }, completion: { (finish:Bool) -> Void in
            })
        }
    }
}
