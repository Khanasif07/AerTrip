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
    @IBOutlet weak var profileContainerView: UIView!
    
    // MARK: - Variable
    private let gradient = CAGradientLayer()
    weak var delegate: SlideMenuProfileImageHeaderViewDelegate?
    
    // MARK: - IBAction
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        delegate?.profileHeaderTapped()
    }
    
    class func instanceFromNib(_ controller: UIViewController) -> SlideMenuProfileImageHeaderView {
        let parentView = UINib(nibName: "SlideMenuProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SlideMenuProfileImageHeaderView
        if controller is ViewProfileVC {
            parentView.familyButton.isHidden = true
        } else {
            parentView.emailIdLabel.isHidden = true
            parentView.mobileNumberLabel.isHidden = true
        }
        
        return parentView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = gradientView.bounds
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
        
        profileImageView.layer.borderColor = AppColors.profileImageBorderColor.cgColor
        profileImageView.layer.borderWidth = 6.0
        
        gradient.frame = gradientView.bounds
        gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, UIColor.white.cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        doInitialSetup()
    }
    
    // MARK: - Helper Method
    
    func doInitialSetup() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        familyButton.layer.cornerRadius = 14.0
    }
}
