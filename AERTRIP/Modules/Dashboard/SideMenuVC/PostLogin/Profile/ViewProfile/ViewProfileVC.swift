//
//  ViewProfileVC.swift
//  AERTRIP
//
//  Created by apple on 18/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

protocol ViewProfileVCDelegate: class {
    func backButtonAction(_ sender: UIButton)
}

class ViewProfileVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: ATTableView!
   @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var headerViewHeight: CGFloat {
        return UIDevice.isIPhoneX ? 84.0 : 64.0
    }
    
    private let headerHeightToAnimate: CGFloat = 30.0
    private var isHeaderAnimating: Bool = false
    
    weak var delegate: ViewProfileVCDelegate?
    let cellIdentifier = "ViewProfileTableViewCell"
    var sections = ["details", "accounts", "logOut"]
    var details = [LocalizedString.TravellerList.localized, LocalizedString.HotelPreferences.localized, LocalizedString.QuickPay.localized, LocalizedString.LinkedAccounts.localized, LocalizedString.NewsLetters.localized]
    var accounts = [LocalizedString.Settings, LocalizedString.Notification]
    var logOut = [LocalizedString.LogOut]
    var profileImageHeaderView: SlideMenuProfileImageHeaderView? {
        didSet {
            self.profileImageHeaderView?.delegate = self
        }
    }
    
    let viewModel = ViewProfileDetailVM()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.travelData = UserInfo.loggedInUser?.travellerDetailModel

        self.profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        self.profileImageHeaderView?.delegate = self
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
        }
        self.doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarStyle = .lightContent
        
        self.viewModel.webserviceForGetTravelDetail()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.profileImageHeaderView?.delegate = self
        self.profileImageHeaderView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.profileImageHeaderView?.isHidden = true
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .profileChanged {
            self.viewModel.webserviceForGetTravelDetail()
        }
    }
    
    // MARK: - Helper Methods
    
    func doInitialSetup() {
        
        self.topNavView.backgroundColor = AppColors.clear
        self.headerViewHeightConstraint.constant = headerViewHeight

        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Edit.rawValue, selectedTitle: LocalizedString.Edit.rawValue, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
        let tintedImage = #imageLiteral(resourceName: "Back").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.topNavView.leftButton.setImage(tintedImage, for: .normal)
        self.topNavView.leftButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.topNavView.leftButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.leftButton.isSelected = false
        
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.firstRightButton.isSelected = false
        
        self.profileImageHeaderView?.delegate = self
        self.setupParallaxHeader()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 60.0))
        tableView.tableFooterView = footerView
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(300.0)//CGFloat(UIDevice.screenHeight * 0.45)
        
        let parallexHeaderMinHeight = self.navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 0.0)
        self.tableView.parallaxHeader.view = profileImageHeaderView
        self.tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        self.tableView.parallaxHeader.height = parallexHeaderHeight
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.tableView.parallaxHeader.delegate = self
        
        self.profileImageHeaderView?.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized)"
        self.profileImageHeaderView?.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        self.profileImageHeaderView?.mobileNumberLabel.text = UserInfo.loggedInUser?.mobileWithISD

        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            self.profileImageHeaderView?.profileImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? AppPlaceholderImage.user, showIndicator: false)
            self.profileImageHeaderView?.backgroundImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder(font: AppFonts.Regular.withSize(40.0), textColor: AppColors.themeBlack).blur ?? UIImage(), showIndicator: false)
            self.profileImageHeaderView?.blurEffectView.alpha = 1.0
        } else {
            
            self.profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            self.profileImageHeaderView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppFonts.Regular.withSize(40.0), textColor: AppColors.themeBlack).blur
            self.profileImageHeaderView?.blurEffectView.alpha = 0.0
        }
        
        self.view.bringSubviewToFront(self.topNavView)
    }
}

extension ViewProfileVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.delegate?.backButtonAction(sender)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if self.viewModel.travelData == nil {
            self.viewModel.travelData = UserInfo.loggedInUser?.travellerDetailModel
        }
        AppFlowManager.default.moveToEditProfileVC(travelData: self.viewModel.travelData, usingFor: .viewProfile)
    }
}
// MARK: - UITableViewDataSource and UITableViewDelegate Methods

extension ViewProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.sections[section] {
        case "details":
            return self.details.count
        case "accounts":
            return self.accounts.count
        case "logOut":
            return self.logOut.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80.0
        }
        else if indexPath.row == 1 {
            return 57.0
        }
        else {
            return 65.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewProfileTableViewCell else {
            fatalError("ViewProfileTableViewCell not found")
        }
        
        switch self.sections[indexPath.section] {
        case "details":
            cell.separatorView.isHidden = true
            cell.menuOptionLabel.isHidden = false
            cell.configureCell(self.details[indexPath.row])
            
            return cell
        case "accounts":
            if self.accounts[indexPath.row].rawValue == "Settings" {
                cell.separatorView.isHidden = false
            } else {
                cell.separatorView.isHidden = true
            }
            cell.configureCell(self.accounts[indexPath.row].rawValue)
            return cell
        case "logOut":
            cell.separatorView.isHidden = false
            cell.configureCell(self.logOut[indexPath.row].rawValue)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.sections[indexPath.section] {
        case "details":
            
            switch indexPath.row {
            case 0:
                self.statusBarStyle = .default
                AppFlowManager.default.moveToTravellerListVC()
                
            case 1:
                self.statusBarStyle = .default
                AppFlowManager.default.moveToViewAllHotelsVC()
                
            case 3:
                self.statusBarStyle = .default
                AppFlowManager.default.moveToLinkedAccountsVC()
                
            default:
                break
            }
            
        case "logOut":
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.LogOut.localized], colors: [AppColors.themeRed])
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.DoYouWantToLogout.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    self.viewModel.webserviceForLogOut()
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension ViewProfileVC: MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        
        let prallexProgress = self.tableView.parallaxHeader.progress
        
        if prallexProgress >= 0.6 {
            self.profileImageHeaderView?.profileImageViewHeightConstraint.constant = 121 * prallexProgress
        }
        
        if prallexProgress <= 0.5 {
            self.statusBarStyle = .default
            self.topNavView.animateBackView(isHidden: false) { [weak self](isDone) in
                self?.topNavView.firstRightButton.isSelected = true
                self?.topNavView.leftButton.isSelected = true
                self?.topNavView.leftButton.tintColor = AppColors.themeGreen
                self?.topNavView.navTitleLabel.text = self?.profileImageHeaderView?.userNameLabel.text
            }
        } else {
            self.statusBarStyle = .lightContent
            self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                self?.topNavView.firstRightButton.isSelected = false
                self?.topNavView.leftButton.isSelected = false
                self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                self?.topNavView.navTitleLabel.text = ""
            }
        }
        self.profileImageHeaderView?.layoutIfNeeded()
        self.profileImageHeaderView?.doInitialSetup()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateForParallexProgress()
    }
}

// MARK: - Profile Header view Delegate methods

extension ViewProfileVC: SlideMenuProfileImageHeaderViewDelegate {
    func profileHeaderTapped() {
        //
    }
    
    func profileImageTapped() {
        NSLog("profile Image Tapped View ProfileVc")
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.travellerDetailModel ?? TravelDetailModel(), usingFor: .viewProfile)
    }
}

extension ViewProfileVC: ViewProfileDetailVMDelegate {
    func willLogOut() {
        //
    }
    
    func didLogOutSuccess() {
        //
        UserInfo.loggedInUserId = nil
        AppFlowManager.default.goToDashboard()
        CoreDataManager.shared.deleteCompleteDB()
    }
    
    func didLogOutFail(errors: ErrorCodes) {
        //
    }
    
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        
        self.viewModel.travelData = data
        
        self.tableView.reloadData()
        
        NotificationCenter.default.post(name: .dataChanged, object: nil)
        self.setupParallaxHeader()
    }
    
    func getFail(errors: ErrorCodes) {

    }
}


