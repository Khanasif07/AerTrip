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
    @IBOutlet var dividerView: ATDividerView!
    
    // MARK: - Variable
    
    private let gradient = CAGradientLayer()
    weak var delegate: SlideMenuProfileImageHeaderViewDelegate?
    var blurEffectView: UIVisualEffectView!
    
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
    
    private func addTapGesture() {
        
//        var tapView = profileContainerView
////        if let superView = self.superview, superView.width < (UIDevice.screenHeight*0.6) {
////            tapView = superView
////        }
//        if let superView = tapView?.superview {
//            tapView = superView
//        }
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuProfileImageHeaderView.profileImageClicked))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
        self.backgroundColor = .red
    }
    
    // Action
    @objc func profileImageClicked() {
        delegate?.profileImageTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDefaultData()
        
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        profileImageView.layer.borderWidth = 6.0
        addBlurToImage()
        doInitialSetup()
        
//        delay(seconds: 0.3) { [weak self] in
            self.addTapGesture()
//        }
    }

    func addBlurToImage() {
        if !UIAccessibility.isReduceTransparencyEnabled {
//            self.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            backgroundImageView.addSubview(blurEffectView)
        } else {
//            self.backgroundColor = .black
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradient.frame = gradientView.bounds
        gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, AppColors.themeWhite]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Helper Method
    private func setupDefaultData() {
        self.profileImageView.image = AppGlobals.shared.getImageFor(firstName: nil, lastName: nil, offSet: CGPoint(x: 0.0, y: 9.0))
        self.userNameLabel.text = ""
        self.emailIdLabel.text = ""
        self.mobileNumberLabel.text = ""
    }
    
    func doInitialSetup() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        familyButton.layer.cornerRadius = familyButton.height / 2.0
    }
}
