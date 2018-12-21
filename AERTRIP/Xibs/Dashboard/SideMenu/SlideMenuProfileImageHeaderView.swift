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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var profileImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var familyButton: UIButton!
    
    // MARK: - Variable
    weak var delegate : SlideMenuProfileImageHeaderViewDelegate?
    
    
    // MARK: - IBAction
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        delegate?.profileHeaderTapped()
        
    }
    
    
    class func instanceFromNib(_ controller : UIViewController) -> SlideMenuProfileImageHeaderView {
      let parentView = UINib(nibName: "SlideMenuProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SlideMenuProfileImageHeaderView
        if controller is ViewProfileVC {
            parentView.familyButton.isHidden = true
        } else {
            parentView.emailIdLabel.isHidden = true
            parentView.mobileNumberLabel.isHidden = true
            
        }
        
        
        return parentView
    }
    
    //Action
    @objc func profileImageClicked() {
        delegate?.profileImageTapped()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuProfileImageHeaderView.profileImageClicked))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(singleTap)
        
        doInitialSetup()
    }
    
    // MARK: - Helper Method
    
    func doInitialSetup() {
         profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        familyButton.layer.cornerRadius = 14.0
    }
}
