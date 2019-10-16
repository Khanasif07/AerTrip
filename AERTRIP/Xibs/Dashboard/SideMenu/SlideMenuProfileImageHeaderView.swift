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
    
    enum UsingFor {
        case viewProfile
        case sideMenu
        case profileDetails
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    @IBOutlet weak var profileImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageAndNameSpace: NSLayoutConstraint!
    @IBOutlet weak var userNameHeightLabel: NSLayoutConstraint!
    @IBOutlet weak var familyButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailAndContactBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageViewWidthConstraint: NSLayoutConstraint!
    // MARK: - Variable
    
    private let gradient = CAGradientLayer()
    weak var delegate: SlideMenuProfileImageHeaderViewDelegate?
    var blurEffectView: UIVisualEffectView!
    var currentlyUsingAs = UsingFor.sideMenu {
        didSet {
            switch currentlyUsingAs {
            case .profileDetails:
                self.setupForProfileDetail()
                
            case .viewProfile:
                self.setupForViewProfile()
                
            default:
                self.setupForSideMenu()
            }
        }
    }
    
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
        
        gradient.frame = gradientView.bounds
        // self.backgroundImageView.frame = self.bounds
    }
    
    private func addTapGesture() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(SlideMenuProfileImageHeaderView.profileImageClicked))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }
    
    // Action
    @objc func profileImageClicked() {
        delegate?.profileImageTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDefaultData()
        
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        profileImageView.layer.borderWidth = 4.0
        addBlurToImage()
        doInitialSetup()
        
        self.addTapGesture()
    }

    func addBlurToImage() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            let blurEffect = UIBlurEffect(style: .light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            backgroundImageView.addSubview(blurEffectView)
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
        familyButton.layer.cornerRadius = familyButton.height / 2.0
        self.makeImageCircular()
    }
    
    private func makeImageCircular() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    private func setupForViewProfile() {
        self.profileImageViewHeightConstraint.constant = 127.0
        self.profileImageAndNameSpace.constant = 23.0
        self.userNameHeightLabel.constant = 33.0
        self.emailAndContactBottomConstraint.constant = 28.0
        
        profileImageView.layer.borderWidth = 4.0
        
        self.userNameLabel.font = AppFonts.Regular.withSize(26.0)
        
        self.emailIdLabel.font = AppFonts.Regular.withSize(14.0)
        self.mobileNumberLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.emailIdLabel.isHidden = false
        self.mobileNumberLabel.isHidden = false
        self.familyButton.isHidden = true
        
        self.layoutIfNeeded()
        
        self.makeImageCircular()
    }
    
    private func setupForSideMenu() {
        self.profileImageViewHeightConstraint.constant = 86.0
        self.profileImageAndNameSpace.constant = 9.0
        self.userNameHeightLabel.constant = 25.0
        self.emailAndContactBottomConstraint.constant = -10.0
        
        profileImageView.layer.borderWidth = 2.0
        
        self.userNameLabel.font = AppFonts.Regular.withSize(20.0)
        
        self.emailIdLabel.isHidden = true
        self.mobileNumberLabel.isHidden = true
        self.familyButton.isHidden = true
        
        self.layoutIfNeeded()
        
        self.makeImageCircular()
    }
    
    private func setupForProfileDetail() {
        self.profileImageViewHeightConstraint.constant = 127.0
        self.profileImageAndNameSpace.constant = 23.0
        self.userNameHeightLabel.constant = 33.0
        self.emailAndContactBottomConstraint.constant = 55.0
        self.familyButtonBottomConstraint.constant = 26.0
        
        profileImageView.layer.borderWidth = 4.0
        
        self.userNameLabel.font = AppFonts.Regular.withSize(26.0)
        
        self.emailIdLabel.text = ""
        self.mobileNumberLabel.text = ""
        self.emailIdLabel.isHidden = true
        self.mobileNumberLabel.isHidden = true
        self.familyButton.isHidden = false
        
        self.layoutIfNeeded()
        
        self.makeImageCircular()
    }
}
