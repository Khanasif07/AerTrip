//
//  SideMenuVC.swift
//  AERTRIP
//
//  Created by Admin on 10/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuVC: BaseVC {
    // MARK: - Properties
    weak private(set) var loginRegistrationButton: ATButton?
    var logoContainerView: SideMenuLogoView! {
        didSet {
            if logoContainerView == nil {
                logoContainerView.removeFromSuperview()
            }
        }
    }
    
    var profileContainerView: SlideMenuProfileImageHeaderView! {
        didSet {
            if profileContainerView == nil {
                profileContainerView.removeFromSuperview()
            }
        }
    }
    
    
    // MARK: -
    
    let viewModel = SideMenuVM()
    let socialViewModel = SocialLoginVM()
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var sideMenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        self.initialSetups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserInfo.loggedInUserId == nil {
            //add the logo view only if user is not logged in 
            if self.logoContainerView == nil {
                self.logoContainerView = SideMenuLogoView.instanceFromNib()
                self.logoContainerView.backgroundColor = AppColors.clear
            }
                        
            self.logoContainerView.frame = CGRect(x: 0.0, y: self.sideMenuTableView.y, width: self.sideMenuTableView.width, height: 150.0)
            self.sideMenuTableView.addSubview(self.logoContainerView)
        }
        else {
            //add the profile view only if user is logged in
            if self.profileContainerView == nil {
                self.profileContainerView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
                self.profileContainerView.backgroundColor = AppColors.clear
            }
            
            self.profileContainerView.userNameLabel.text = UserInfo.loggedInUser?.profileName ?? LocalizedString.na.localized
            self.profileContainerView.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
            self.profileContainerView.mobileNumberLabel.text = UserInfo.loggedInUser?.mobile ?? LocalizedString.na.localized
            
            if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
                self.profileContainerView.profileImageView.kf.setImage(with: URL(string: imagePath))
            }
            else {
                profileContainerView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
                profileContainerView.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            }
            
            self.profileContainerView.frame = CGRect(x: 0.0, y: 50.0, width: self.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
            self.profileContainerView.emailIdLabel.isHidden = true
            self.profileContainerView.mobileNumberLabel.isHidden = true
            self.profileContainerView.profileContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.profileContainerView.backgroundImageView.isHidden = true
            self.profileContainerView.gradientView.isHidden = true
            self.profileContainerView.dividerView.isHidden = true
            self.profileContainerView.isUserInteractionEnabled = false
            self.profileContainerView.layoutSubviews()
            self.profileContainerView.emailIdLabel.alpha = 0.0
            self.profileContainerView.mobileNumberLabel.alpha = 0.0
            self.profileContainerView.backgroundImageView.alpha = 0.0
            self.profileContainerView.gradientView.alpha = 0.0
            self.profileContainerView.dividerView.alpha = 0.0
            self.profileContainerView.translatesAutoresizingMaskIntoConstraints = true
            self.sideMenuTableView.addSubview(self.profileContainerView)
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // MARK: - IBAction
    
    // MARK: -
    
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
//       self.socialViewModel.fbLogin(vc: self, completionBlock: nil)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
//        self.socialViewModel.googleLogin()
    }
    
    @IBAction func linkedLoginButtonAction(_ sender: UIButton) {
//        self.socialViewModel.linkedLogin()
    }
}

// MARK: - Extension SetupView

// MARK: -

private extension SideMenuVC {
    func initialSetups() {
        self.registerXibs()
    }
    
    func registerXibs() {
        self.sideMenuTableView.register(UINib(nibName: "SideMenuOptionsLabelCell", bundle: nil), forCellReuseIdentifier: "SideMenuOptionsLabelCell")
        self.sideMenuTableView.register(UINib(nibName: "SideMenuProfileImageCell", bundle: nil), forCellReuseIdentifier: "SideMenuProfileImageCell")
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.delegate = self
    }
}

// MARK: - Extension Target Methods

// MARK: -

extension SideMenuVC {
    
    @objc func loginAndRegistrationButtonAction(_ sender: ATButton) {
        self.loginRegistrationButton = sender
        self.logoContainerView.removeFromSuperview()
        self.logoContainerView.frame = CGRect(x: self.sideMenuTableView.x, y: self.sideMenuTableView.y, width: self.sideMenuTableView.width, height: 150.0)
        AppFlowManager.default.mainNavigationController.view.addSubview(self.logoContainerView)
        AppFlowManager.default.moveToSocialLoginVC()
    }
    
    @objc func viewProfileButtonAction(_ sender: ATButton) {
        self.profileContainerView.removeFromSuperview()
        self.profileContainerView.frame = CGRect(x: self.sideMenuTableView.x, y: 50.0, width: self.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
        AppFlowManager.default.mainNavigationController.view.addSubview(self.profileContainerView)
        AppFlowManager.default.moveToViewProfileVC()
    }
}

// MARK: - Extension SetupView

// MARK: -

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = UserInfo.loggedInUserId {
            return self.viewModel.cellForLoginUser.count + 1
            
        } else {
            return self.viewModel.displayCellsForGuest.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            if let _ = UserInfo.loggedInUserId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuProfileImageCell", for: indexPath) as? SideMenuProfileImageCell else {
                    fatalError("SideMenuProfileImageCell not found")
                }
                
                cell.populateData()
                cell.profileImage.isHidden = true
                cell.userNameLabel.isHidden = true
                cell.viewProfileButton.addTarget(self, action: #selector(self.viewProfileButtonAction(_:)), for: .touchUpInside)
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestSideMenuHeaderCell", for: indexPath) as? GuestSideMenuHeaderCell else {
                    fatalError("GuestSideMenuHeaderCell not found")
                }
                
                cell.logoContainerView.isHidden = true
                cell.loginAndRegisterButton.addTarget(self, action: #selector(self.loginAndRegistrationButtonAction(_:)), for: .touchUpInside)
                
                return cell
            }
            
        case 1:
            
            if let _ = UserInfo.loggedInUserId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewAccountCell", for: indexPath) as? SideMenuViewAccountCell else {
                    fatalError("SideMenuViewAccountCell not found")
                }
                
                cell.populateData()
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                    fatalError("SideMenuOptionsLabelCell not found")
                }
                
                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
                return cell
            }
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                fatalError("SideMenuOptionsLabelCell not found")
            }
            
            if let _ = UserInfo.loggedInUserId {
                cell.populateData(text: self.viewModel.cellForLoginUser[indexPath.row - 2])
                
                if indexPath.row == 6 {
                    cell.sepratorView.isHidden = false
                }
                
            } else {
                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
