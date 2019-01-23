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
    
    // MARK: - IBOutlets
    
    // MARK: -
    
    @IBOutlet var sideMenuTableView: ATTableView!
    
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
                self.sideMenuTableView.addSubview(self.profileContainerView)
            }
        }
    }
    
    func getAppLogoView() -> SideMenuLogoView {
        let view = SideMenuLogoView.instanceFromNib()
        view.backgroundColor = AppColors.clear
        self.updateLogoView(view: view)
        
        return view
    }
    
    private func updateLogoView(view: SideMenuLogoView) {
        view.frame = CGRect(x: 0.0, y: self.sideMenuTableView.y, width: self.sideMenuTableView.width, height: 150.0)
    }
    
    func getProfileView() -> SlideMenuProfileImageHeaderView {
        //add the profile view only if user is logged in
        let view = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        view.backgroundColor = AppColors.clear
        self.updateProfileView(view: view)
        
        return view
    }
    
    func updateProfileView(view: SlideMenuProfileImageHeaderView) {
        view.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized ) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized )"
        view.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        if let mobileNumber = UserInfo.loggedInUser?.mobile ,let isd = UserInfo.loggedInUser?.isd {
              view.mobileNumberLabel.text = "\(isd) \(mobileNumber)"
        }
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            view.profileImageView.kf.setImage(with: URL(string: imagePath))
            view.backgroundImageView.kf.setImage(with: URL(string: imagePath))
        }
        else {
            view.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            view.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
        
        view.frame = CGRect(x: 0.0, y: 50.0, width: self.sideMenuTableView.width, height: UIDevice.screenHeight*0.22)
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
