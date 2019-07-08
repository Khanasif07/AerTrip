//
//  SideMenuVC.swift
//  AERTRIP
//
//  Created by Admin on 10/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SideMenuVCDelegate: class {
    func loginRegisterAction(_ sender: ATButton)
    func viewProfileAction(_ sender: ATButton)
}

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
    
    weak var delegate: SideMenuVCDelegate?
    
    var profileSuperView: UIView!
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var sideMenuTableView: ATTableView!
    @IBOutlet var socialOptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserInfo.loggedInUserId == nil {
            //add the logo view only if user is not logged in
            if let view = self.logoContainerView {
                self.updateLogoView(view: view)
            }
            else {
                self.logoContainerView = self.getAppLogoView()
                self.sideMenuTableView.addSubview(self.logoContainerView)
            }
        }
        else {
            //add the profile view only if user is logged in
            if let view = self.profileContainerView {
                self.updateProfileView(view: view)
            }
            else {
                self.profileContainerView = self.getProfileView()
                self.profileContainerView.delegate = self
                self.profileContainerView.isUserInteractionEnabled = true
                self.profileSuperView?.addSubview(self.profileContainerView)
            }
        }
    }
    
    override func initialSetup() {
        self.view.backgroundColor = AppColors.screensBackground.color
        
        self.socialOptionView.frame = CGRect(x: 0.0, y: 0.0, width: self.sideMenuTableView.width, height: (75.0))
        self.sideMenuTableView.tableFooterView = self.socialOptionView
        self.registerXibs()
    }
    
    @objc func profileTapped() {
        printDebug("dfasdfasdf")
    }
    
    func getAppLogoView() -> SideMenuLogoView {
        let view = SideMenuLogoView.instanceFromNib()
        view.backgroundColor = AppColors.clear
        self.updateLogoView(view: view)
        
        return view
    }
    
    private func updateLogoView(view: SideMenuLogoView) {
        view.frame = CGRect(x: 0.0, y: self.sideMenuTableView.y, width: self.sideMenuTableView.width, height: 179.0)
    }
    
    func getProfileView() -> SlideMenuProfileImageHeaderView {
        //add the profile view only if user is logged in
        let view = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        view.profileImageView.layer.borderWidth = 3.0
        view.backgroundColor = AppColors.clear
        self.updateProfileView(view: view)
        
        return view
    }
    
    func updateProfileView(view: SlideMenuProfileImageHeaderView) {
        view.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized ) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized )"
        view.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        view.mobileNumberLabel.text = UserInfo.loggedInUser?.mobileWithISD
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            //view.profileImageView.kf.setImage(with: URL(string: imagePath))
            view.profileImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? UIImage(), showIndicator: false)
            //  view.backgroundImageView.kf.setImage(with: URL(string: imagePath))
            view.backgroundImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? UIImage(), showIndicator: false)
        }
        else {
            view.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            view.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(textColor: AppColors.themeBlack)
        }
        
        view.frame = CGRect(x: 0.0, y: 40.0, width: self.profileSuperView?.width ?? 0.0, height: self.profileSuperView?.height ?? 0.0)
        view.emailIdLabel.isHidden = true
        view.mobileNumberLabel.isHidden = true
        view.profileContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.backgroundImageView.isHidden = true
        view.gradientView.isHidden = true
        view.dividerView.isHidden = true
        view.isUserInteractionEnabled = false
        view.layoutSubviews()
        view.emailIdLabel.alpha = 0.0
        view.mobileNumberLabel.alpha = 0.0
        view.backgroundImageView.alpha = 0.0
        view.gradientView.alpha = 0.0
        view.dividerView.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = true
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

extension SideMenuVC: SlideMenuProfileImageHeaderViewDelegate {
    func profileHeaderTapped() {
        
    }
    
    func profileImageTapped() {
        self.delegate?.viewProfileAction(ATButton())
    }
}

private extension SideMenuVC {
    
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
        self.delegate?.loginRegisterAction(sender)
    }
    
    @objc func viewProfileButtonAction(_ sender: ATButton) {
        self.delegate?.viewProfileAction(sender)
    }
}

// MARK: - Extension SetupView

// MARK: -

extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = UserInfo.loggedInUserId {
            return self.viewModel.cellForLoginUser.count + 2
            
        } else {
            return self.viewModel.displayCellsForGuest.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
            if let _ = UserInfo.loggedInUserId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuProfileImageCell", for: indexPath) as? SideMenuProfileImageCell else {
                    return UITableViewCell()
                }
                
                self.profileSuperView = cell.profileSuperView
                cell.viewProfileButton.addTarget(self, action: #selector(self.viewProfileButtonAction(_:)), for: .touchUpInside)
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestSideMenuHeaderCell", for: indexPath) as? GuestSideMenuHeaderCell else {
                    return UITableViewCell()
                }
                
                cell.logoContainerView.isHidden = true
                cell.loginAndRegisterButton.addTarget(self, action: #selector(self.loginAndRegistrationButtonAction(_:)), for: .touchUpInside)
                
                return cell
            }
            
        case 1:
            
            if let _ = UserInfo.loggedInUserId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuViewAccountCell", for: indexPath) as? SideMenuViewAccountCell else {
                    return UITableViewCell()
                }
                
                cell.populateData()
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                    return UITableViewCell()
                }
                
                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
                return cell
            }
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                return UITableViewCell()
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
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 75.0 //+ AppFlowManager.default.safeAreaInsets.bottom
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.socialOptionView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0, let _ = UserInfo.loggedInUserId {
            self.viewProfileButtonAction(ATButton())
        }
        else if indexPath.row == 1 {
            //view account
            AppFlowManager.default.moveToAccountDetailsScreen()
        }
        else if indexPath.row == 2 , UserInfo.loggedInUser != nil {
            AppFlowManager.default.moveToMyBookingsVC()
        }
        else if indexPath.row == 6 {
            //Settings
            AppFlowManager.default.moveToSettingsVC()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return (UserInfo.loggedInUserId == nil) ? 267.0 : 200
            
        case 1:
            return (UserInfo.loggedInUserId == nil) ? 60.0 : 63.0
            
        default:
            return (UserInfo.loggedInUserId == nil) ? 60.03 : 66.7
        }
    }
}
