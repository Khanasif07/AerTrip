//
//  SideMenuProfileHeaderView.swift
//  AERTRIP
//
//  Created by Rishabh on 30/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuProfileHeaderView: UIView {
    // MARK: - IBOutlet
    
    enum UsingFor {
        case viewProfile
        case sideMenu
        case profileDetails
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
        
    // MARK: - Variable
    
    private var isNavBarHidden = true
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
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - IBAction
    
    @IBAction func viewProfileButtonTapped(_ sender: Any) {
        delegate?.profileHeaderTapped()
    }
    
    class func instanceFromNib(isFamily: Bool = false) -> SlideMenuProfileImageHeaderView {
        let parentView = UINib(nibName: "SideMenuProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SlideMenuProfileImageHeaderView
        
        parentView.familyButton.isHidden = !isFamily
        parentView.emailIdLabel.isHidden = isFamily
        parentView.mobileNumberLabel.isHidden = isFamily
        
        return parentView
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.frame = gradientView.bounds
        self.backgroundImageView.frame = self.bounds
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
        
        
        addBlurToImage()
        doInitialSetup()
        activityIndicatorView.isHidden = true
        
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
    
    func makeImageCircular() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        profileImageView.layer.borderWidth = 2.5
        profileImageView.layer.masksToBounds = true
    }
    
    private func setupForViewProfile() {
        profileImageView.layer.borderWidth = 2.5
        
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
        
        profileImageView.layer.borderWidth = 2.5
        
        self.userNameLabel.font = AppFonts.Regular.withSize(20.0)
        
        self.emailIdLabel.isHidden = true
        self.mobileNumberLabel.isHidden = true
        self.familyButton.isHidden = true
        
        self.layoutIfNeeded()
        
        self.makeImageCircular()
    }
    
    private func setupForProfileDetail() {

        profileImageView.layer.borderWidth = 2.5
        
        self.userNameLabel.font = AppFonts.Regular.withSize(26.0)
        
        self.emailIdLabel.text = ""
        self.mobileNumberLabel.text = ""
        self.emailIdLabel.isHidden = true
        self.mobileNumberLabel.isHidden = true
        self.familyButton.isHidden = false
        
        self.layoutIfNeeded()
        
        self.makeImageCircular()
    }
    
    func startLoading() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    
}

