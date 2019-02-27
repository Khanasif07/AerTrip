//
//  ATSwitcher.swift
//  SwitcherExample
//
//  Created by apple on 19/02/19.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ATSwitcherChangeValueDelegate {
    func switcherDidChangeValue(switcher: ATSwitcher,value: Bool)
}

class ATSwitcher: UIView {

    var button: UIButton!
    var buttonLeftConstraint: NSLayoutConstraint!
    var delegate: ATSwitcherChangeValueDelegate?
    
    @IBInspectable var on: Bool = false
    @IBInspectable var originalImage:UIImage?
    @IBInspectable var selectedImage:UIImage?
    @IBInspectable var selectedColor:UIColor = UIColor(red: 126/255.0, green: 134/255.0, blue: 249/255.0, alpha: 1)
    @IBInspectable var originalColor:UIColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 211/255.0, alpha: 1)
    
    private var offCenterPosition: CGFloat!
    private var onCenterPosition: CGFloat!
    
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
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControl.Event.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        offCenterPosition = self.bounds.height * 0.07
        onCenterPosition = self.bounds.width - (self.bounds.height * 0.9)
        
        if on == true {
            self.backgroundColor = selectedColor
        } else {
            self.backgroundColor = originalColor
        }
        
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        initLayout()
        animationSwitcherButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private func initLayout() {
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLeftConstraint = button.leftAnchor.constraint(equalTo: self.leftAnchor)
        buttonLeftConstraint.isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switcherButtonTouch(_ sender: AnyObject) {
        on = !on
        animationSwitcherButton()
        delegate?.switcherDidChangeValue(switcher: self, value: on)
    }
    
    func animationSwitcherButton() {
        if on == true {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = true
                self.buttonLeftConstraint.constant = self.onCenterPosition
                self.layer.borderColor = AppColors.clear.cgColor
                self.layoutIfNeeded()
                self.backgroundColor = self.selectedColor
                }, completion: { (finish:Bool) -> Void in
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = false
                self.buttonLeftConstraint.constant = 0
                self.layoutIfNeeded()
                self.backgroundColor = self.originalColor
                self.layer.borderColor = AppColors.themeGray10.cgColor
                self.layer.borderWidth = 1.5
                }, completion: { (finish:Bool) -> Void in
            })
        }
    }
}
