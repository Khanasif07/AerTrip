//
//  ATGuestButton.swift
//  AERTRIP
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum GuestButtonType{
    case adult
    case child
}

class ATGuestButton: UIButton {
    let placeholderImage = UIImageView()
    var btnType = GuestButtonType.adult
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configButton()
    }
    
    private func configButton() {
        self.setImage(#imageLiteral(resourceName: "adult_deSelected"), for: .normal)
        placeholderImage.frame = self.bounds
        placeholderImage.image = nil
        placeholderImage.contentMode = .scaleAspectFit
        placeholderImage.clipsToBounds = true
        self.addSubview(placeholderImage)
        //self.addRequiredAction()
    }
    
//    private func addRequiredAction() {
//        self.adjustsImageWhenHighlighted = false
//        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
//        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpInside)
//        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpOutside)
//    }
//
//    @objc private func buttonPressed(_ sender: UIButton) {
//        //sender.isSelected ? self.selectedState() : self.deselectedState()
//    }
//
//    @objc private func buttonReleased(_ sender: UIButton) {
//        //sender.isSelected ? self.selectedState() : self.deselectedState()
//    }
    
    
    public func selectedState() {
        self.placeholderImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.placeholderImage.image = #imageLiteral(resourceName: "adult_selected")
                        self?.placeholderImage.transform = .identity
            },
                       completion: nil)
    }
    
    public func deselectedState() {
        self.placeholderImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.placeholderImage.transform = .identity
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.placeholderImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (true) in
            self.placeholderImage.image = nil
            self.placeholderImage.transform = .identity
        }
    }
    
}
