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
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.placeholderImage.frame = self.bounds
    }
    
    public func initialSetup() {
        self.setImage(nil, for: .normal)
        placeholderImage.frame = self.bounds
        //self.setBackgroundImage(#imageLiteral(resourceName: "adult_deSelected"), for: .application)
        placeholderImage.image = #imageLiteral(resourceName: "adult_deSelected")
        placeholderImage.contentMode = .scaleAspectFit
        self.addSubview(placeholderImage)
      //self.btnType == .adult ? #imageLiteral(resourceName: "adult_deSelected") : #imageLiteral(resourceName: "child_deSelected")
        self.isSpringLoaded = true
    }
    
    public func selectedState() {
        let image = #imageLiteral(resourceName: "adult_selected")
        //self.btnType == .adult ? #imageLiteral(resourceName: "adult_selected") : #imageLiteral(resourceName: "child_selected")
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.setImage(image, for: .normal)
                        self?.transform = .identity
        }) { (true) in
            self.transform = .identity
            self.setImage(image, for: .normal)
        }
    }
    
    public func deselectedState() {
        self.transform = .identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (true) in
            self.setImage(nil, for: .normal)
            self.transform = .identity
        }
    }
    
}
