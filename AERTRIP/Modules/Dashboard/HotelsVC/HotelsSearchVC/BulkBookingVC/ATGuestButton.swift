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
    private var isStateAnimating: Bool = false
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
        //self.setImage(#imageLiteral(resourceName: "adult_deSelected"), for: .normal)
        placeholderImage.frame = self.bounds
        placeholderImage.image = nil
        placeholderImage.contentMode = .scaleAspectFit
        placeholderImage.clipsToBounds = true
        self.addSubview(placeholderImage)
    }
    
    public func selectedState(selectedImage: UIImage) {
        guard !self.isStateAnimating else {return}
        
        self.isStateAnimating = true
        self.placeholderImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: AppConstants.kAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.placeholderImage.image = selectedImage
                        self?.placeholderImage.transform = .identity
        }){ (isDone) in
            self.isStateAnimating = false
        }
    }
    
    public func deselectedState() {
        guard !self.isStateAnimating else {return}
        self.isStateAnimating = true
        self.placeholderImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.placeholderImage.transform = .identity
        UIView.animate(withDuration: AppConstants.kAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .allowAnimatedContent,
                       animations: { [weak self] in
                        self?.placeholderImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (isDone) in
            self.isStateAnimating = false
            self.placeholderImage.image = nil
            self.placeholderImage.transform = .identity
        }
    }
}
