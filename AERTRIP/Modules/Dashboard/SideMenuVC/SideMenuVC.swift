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
    
    @IBOutlet weak var sideMenuTableView: ATTableView!
    @IBOutlet weak var socialOptionView: UIView!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccountSummary()
    }
    
    
    override func dataChanged(_ note: Notification) {
        printDebug("data changed notfication received")
        //        resetItems()
        updateProfileView(view: getProfileView())
        sideMenuTableView.reloadData()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserInfo.loggedInUserId == nil {
            //add the logo view only if user is not logged in
            if let view = self.logoContainerView {
                //                self.updateLogoView(view: view)
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
            }
        }
        
    }
    
    
    
    override func initialSetup() {
        self.view.backgroundColor = AppColors.screensBackground.color
        self.socialOptionView.frame = CGRect(x: 0.0, y: 0.0, width: self.sideMenuTableView.width, height: (77.0))
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
    
    func getAccountSummary() {
        if let _ = UserInfo.loggedInUserId {
            DispatchQueue.backgroundAsync() { [weak self] in
                self?.viewModel.webserviceForGetAccountSummary()
            }
        }
    }
    
    func getProfileView() -> SlideMenuProfileImageHeaderView {
        //add the profile view only if user is logged in
        let view = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        //  view.profileImageViewBottomConstraint.constant = 10
        view.currentlyUsingAs = .sideMenu
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
            view.backgroundImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder(font:AppConstants.profileViewBackgroundNameIntialsFont) ?? UIImage(), showIndicator: false)
        }
        else {
            view.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            view.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font:AppConstants.profileViewBackgroundNameIntialsFont, textColor: AppColors.themeBlack)
        }
        view.frame = CGRect(x: 0.0, y: 40.0, width: self.profileSuperView?.width ?? 0.0, height: self.profileSuperView?.height ?? 0.0)
        view.emailIdLabel.isHidden = true
        view.mobileNumberLabel.isHidden = true
        view.profileContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.backgroundImageView.isHidden = true
        view.gradientView.isHidden = true
        view.dividerView.isHidden = true
        view.userNameLabel.font = AppFonts.Regular.withSize(20.0)
        view.isUserInteractionEnabled = false
        view.layoutSubviews()
        view.emailIdLabel.alpha = 0.0
        view.mobileNumberLabel.alpha = 0.0
        view.backgroundImageView.alpha = 0.0
        view.gradientView.alpha = 0.0
        view.dividerView.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = true
        //        view.profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    
    
    // MARK: - IBAction
    
    // MARK: -
    
    @IBAction func facebookBtnAction(_ sender: UIButton) {
        AppSocialNetwork.Facebook.openPage()
    }
    
    @IBAction func instagramBtnAction(_ sender: UIButton) {
        AppSocialNetwork.Instagram.openPage()
    }
    
    @IBAction func twitterBtnAction(_ sender: UIButton) {
        AppSocialNetwork.Twitter.openPage()
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
        delay(seconds: 0.15) { [weak self] in
            self?.delegate?.loginRegisterAction(sender)
        }
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
                cell.userInfo = UserInfo.loggedInUser
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
                if (UserInfo.loggedInUser?.userCreditType ?? .statement  == .topup) || (UserInfo.loggedInUser?.userCreditType ?? .statement  == .statement) ||  (UserInfo.loggedInUser?.userCreditType ?? .statement  == .billwise){
                    cell.totalDueAmountLabel.text = "Amount Due"
                } else {
                    cell.totalDueAmountLabel.text = "Account Balance"
                }
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                    return UITableViewCell()
                }
                cell.selectionStyle = .gray
                cell.populateData(text: self.viewModel.displayCellsForGuest[indexPath.row - 1])
                return cell
            }
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuOptionsLabelCell", for: indexPath) as? SideMenuOptionsLabelCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .gray
            if let _ = UserInfo.loggedInUserId {
                let title = self.viewModel.cellForLoginUser[indexPath.row - 2]
                //                switch indexPath.row{
                //                case 2:
                //                    cell.displayTextLabelTopConstraint.constant = 18.0
                //                case 3:
                //                    cell.displayTextLabelTopConstraint.constant = 13.0
                //                case 4:
                //                    cell.displayTextLabelTopConstraint.constant = 11.0
                //                case 6:
                //                    cell.displayTextLabelTopConstraint.constant = -6.0
                //                default:
                //                    cell.displayTextLabelTopConstraint.constant = 0.0
                //                }
                cell.populateData(text: title)
                cell.sepratorView.isHidden = !title.isEmpty
                
            } else {
                
                //                switch indexPath.row{
                //                case 2:
                //                    cell.displayTextLabelTopConstraint.constant = 2.0
                //                case 4:
                //                    cell.displayTextLabelTopConstraint.constant = -2.0
                //                case 5:
                //                    cell.displayTextLabelTopConstraint.constant = -4.0
                //                default:
                //                    cell.displayTextLabelTopConstraint.constant = 0.0
                //                }
                
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
        if let _ = UserInfo.loggedInUserId {
            //current user
            switch indexPath.row {
            case 0:
                //profile
                self.viewProfileButtonAction(ATButton())
                
            case 1:
                //view account
                AppFlowManager.default.moveToAccountDetailsScreen()
                
            case 2:
                //my booking
                AppFlowManager.default.moveToMyBookingsVC()
                
            case 3:
                // Offers
                if let url = URL(string: APIEndPoint.offers.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.cellForLoginUser[indexPath.row - 2], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
            case 4:
                //my Notifications
                AppFlowManager.default.moveToNotificationVC()
                
            case 6:
                //settings
                AppFlowManager.default.moveToSettingsVC()
                
            case 7:
                //Support
                if let url = URL(string: APIEndPoint.contact.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.cellForLoginUser[indexPath.row - 2], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
                
            case 8:
                //RateUs
                self.openUrl(AppKeys.kAppStoreLink)
                
            default:
                AppToast.default.showToastMessage(message: "This feature is coming soon")
            }
        }
        else {
            //guest user
            switch indexPath.row {
                
            case 0:
                break
            case 1:
                //why Aertrip
                if let url = URL(string: APIEndPoint.whyAertrip.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.displayCellsForGuest[indexPath.row - 1], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
            case 2:
                //Smart Sort
                if let url = URL(string: APIEndPoint.smartSort.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.displayCellsForGuest[indexPath.row - 1], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
            case 3:
                //offers
                if let url = URL(string: APIEndPoint.offers.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.displayCellsForGuest[indexPath.row - 1], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
            case 4:
                //contact us
                if let url = URL(string: APIEndPoint.contact.rawValue) {
                    AppFlowManager.default.showURLOnATWebView(url, screenTitle:  self.viewModel.displayCellsForGuest[indexPath.row - 1], presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
                }
            case 5:
                //settings
                AppFlowManager.default.moveToSettingsVC()
                
            default:
                printDebug("DO Nothing")
                AppToast.default.showToastMessage(message: "This feature is coming soon")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 2, self.viewModel.cellForLoginUser[indexPath.row - 2].isEmpty {
            //make divider
            return 10.0
        }
        else {
            switch indexPath.row {
            case 0:
                return (UserInfo.loggedInUserId == nil) ? 267.0 : UITableView.automaticDimension
                
            case 1:
                return (UserInfo.loggedInUserId == nil) ? 61.5 : 82
                
            default:
                if let _ = UserInfo.loggedInUserId {
                    return 61.0
                } else {
                    return 62.0
                }
                //                return (UserInfo.loggedInUserId == nil) ? ( indexPath.row == 6) ? 61.0 : 64.0 : 61.0
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == sideMenuTableView {
            printDebug(scrollView.contentOffset)
        }
    }
}

// MARK: - Extension SideMenuVM Delegate

extension SideMenuVC: SideMenuVMDelegate {
    
    func willGetAccountSummary() {
    }
    
    func getAccountSummarySuccess() {
        DispatchQueue.mainAsync {
            self.sideMenuTableView.reloadRow(at: IndexPath(row: 1, section: 0), with: .none)
        }
    }
    
    func getAccountSummaryFail(errors: ErrorCodes) {
        
    }
    
    
}


