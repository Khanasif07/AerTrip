//
//  SlideMenuProfileImageHeaderView.swift
//  AERTRIP
//
//  Created by apple on 17/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SlideMenuProfileImageHeaderViewDelegate: class {
    func profileHeaderTapped()
    func profileImageTapped()
}

class SlideMenuProfileImageHeaderView: UIView {
    // MARK: - IBOutlet
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailIdLabel: UILabel!
    @IBOutlet var profileImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var familyButton: UIButton!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var profileContainerView: UIView!
    @IBOutlet var dividerView: UIView!
    
    // MARK: - Variable
    
    private let gradient = CAGradientLayer()
    weak var delegate: SlideMenuProfileImageHeaderViewDelegate?
    var blurEffectView :UIVisualEffectView = UIVisualEffectView()
    
    // MARK: - IBAction
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        delegate?.profileHeaderTapped()
    }
    
    class func instanceFromNib(isFamily: Bool = false) -> SlideMenuProfileImageHeaderView {
        let parentView = UINib(nibName: "SlideMenuProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SlideMenuProfileImageHeaderView
        
        parentView.familyButton.isHidden = !isFamily
        parentView.emailIdLabel.isHidden = isFamily
        parentView.mobileNumberLabel.isHidden = isFamily
        return parentView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // self.backgroundImageView.frame = self.bounds
    }
    
    // Action
    @objc func profileImageClicked() {
        delegate?.profileImageTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuProfileImageHeaderView.profileImageClicked))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(singleTap)
        
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        profileImageView.layer.borderWidth = 6.0
        addBlurToImage()
        doInitialSetup()
    }
    
    func addGradient() {
        gradient.frame = gradientView.bounds
        gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, UIColor.white.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func addBlurToImage() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            backgroundImageView.addSubview(blurEffectView)
        } else {
            self.backgroundColor = .black
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        gradient.frame = gradientView.bounds
        gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, UIColor.white.cgColor]
         // gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, UIColor.white.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Helper Method
    
    func doInitialSetup() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        familyButton.layer.cornerRadius = 14.0
    }
}
