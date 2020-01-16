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
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    // Make navigation bar height as 88.0 on iphone X .
    private var headerViewHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    
    private var isNavBarHidden:Bool = true
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
    
    var maxValue: CGFloat = 1.0
    var minValue: CGFloat = 0.0
    var finalMaxValue: Int = 0
    var currentProgress: CGFloat = 0
    var currentProgressIntValue: Int = 0
    
    var isScrollingFirstTime: Bool = true
    
    let viewModel = ViewProfileDetailVM()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.travelData = UserInfo.loggedInUser?.travellerDetailModel
        
        self.profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        self.profileImageHeaderView?.currentlyUsingAs = .viewProfile
        self.profileImageHeaderView?.delegate = self
        //        self.profileImageHeaderView?.profileImageViewBottomConstraint.constant = 18
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
        }
        self.doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let main = AppFlowManager.default.mainHomeVC, main.isPushedToNext {
            self.statusBarStyle = topNavView.backView.isHidden ? .lightContent : .default
        }
        else if let sideMenu = AppFlowManager.default.sideMenuController, !sideMenu.isOpen {
            self.statusBarStyle = .lightContent
        }
        else {
            self.statusBarStyle = .default
        }
        
        // self.topNavView.backgroundType = .blurAnimatedView(isDark: false)
        DispatchQueue.delay(0.2) { [weak self] in
            self?.viewModel.webserviceForGetTravelDetail()
        }
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.profileImageHeaderView?.delegate = self
        self.profileImageHeaderView?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.profileImageHeaderView?.isHidden = true
        delay(seconds: 0.5) { [weak self] in
            self?.topNavView.isToShowIndicatorView = false
        }
        self.topNavView.configureFirstRightButton( normalTitle: LocalizedString.Edit.localized, selectedTitle: LocalizedString.Edit.localized, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
        
    }
    
    
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .profileSavedOnServer {
            // self.viewModel.webserviceForGetTravelDetail()
        }
    }
    
    
    
    // MARK: - Helper Methods
    
    func doInitialSetup() {
        
        self.view.backgroundColor = AppColors.themeWhite
        self.topNavView.backgroundColor = AppColors.clear
        self.headerViewHeightConstraint.constant = headerViewHeight
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        
        let editStr = "\(LocalizedString.Edit.rawValue) "
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: editStr, selectedTitle: editStr, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
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
        let parallexHeaderHeight = CGFloat(304.0)//CGFloat(UIDevice.screenHeight * 0.45)
        
        let parallexHeaderMinHeight = self.navigationController?.navigationBar.bounds.height ?? 74
        if !self.currentProgress.isZero {
            CGAffineTransform(scaleX: (CGFloat(self.currentProgress)) , y: (CGFloat(currentProgress))).translatedBy(x: 0, y: CGFloat(2200 * (Float(currentProgressIntValue) / 1000)))
            
        }
        self.profileImageHeaderView?.currentlyUsingAs = .viewProfile
        profileImageHeaderView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 0.0)
        self.profileImageHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.parallaxHeader.view = profileImageHeaderView
        self.tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        self.tableView.parallaxHeader.height = parallexHeaderHeight
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.profileImageHeaderView?.widthAnchor.constraint(equalToConstant: tableView?.width ?? 0.0).isActive = true
        self.tableView.parallaxHeader.delegate = self
        self.updateUserData()
       // self.view.bringSubviewToFront(self.topNavView)
    }
    
    func updateUserData() {
        self.profileImageHeaderView?.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized)"
        self.profileImageHeaderView?.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        self.profileImageHeaderView?.mobileNumberLabel.text = UserInfo.loggedInUser?.mobileWithISD
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            self.profileImageHeaderView?.profileImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? AppPlaceholderImage.user, showIndicator: false)
            self.profileImageHeaderView?.backgroundImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder(font:AppConstants.profileViewBackgroundNameIntialsFont, textColor: AppColors.themeBlack).blur ?? UIImage(), showIndicator: false)
            
            self.profileImageHeaderView?.blurEffectView.alpha = 1.0
        } else {
            
            self.profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            self.profileImageHeaderView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppConstants.profileViewBackgroundNameIntialsFont, textColor: AppColors.themeBlack).blur
            self.profileImageHeaderView?.blurEffectView.alpha = 0.0
        }
    }
    
    func getUpdatedTitle() -> String {
        var updatedTitle = self.profileImageHeaderView?.userNameLabel.text ?? ""
        if updatedTitle.count > 24 {
            updatedTitle = updatedTitle.substring(from: 0, to: 8) + "..." +  updatedTitle.substring(from: updatedTitle.count - 8, to: updatedTitle.count)
        }
        return updatedTitle
    }
}

extension ViewProfileVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.delegate?.backButtonAction(sender)
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        if self.viewModel.travelData == nil {
            self.viewModel.travelData = UserInfo.loggedInUser?.travellerDetailModel
        }
        self.topNavView.configureFirstRightButton( normalTitle: "", selectedTitle: "")
        self.topNavView.isToShowIndicatorView = true
        self.topNavView.startActivityIndicaorLoading()
        AppFlowManager.default.moveToEditProfileVC(travelData: self.viewModel.travelData, usingFor: .viewProfile)
        delay(seconds: 0.5) { [weak self] in
            self?.topNavView.stopActivityIndicaorLoading()
        }
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
            return 47.0
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
            self.statusBarStyle = .default
            switch indexPath.row {
            // Open traveller detail listing
            case 0:
                AppFlowManager.default.moveToTravellerListVC()
                
            // Open View All hotel details
            case 1:
                AppFlowManager.default.moveToViewAllHotelsVC()
                
            // Open Quick pay
            case 2:
                AppFlowManager.default.moveToQuickPayVC()
                
            // Open linked accout VC
            case 3:
                AppFlowManager.default.moveToLinkedAccountsVC()
                
            default:
                break
            }
            
        case "accounts":
            self.statusBarStyle = .default
            if indexPath.row == 0 {
                //settings
                AppFlowManager.default.moveToSettingsVC()
            } else {
                AppFlowManager.default.moveToNotificationVC()
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
    @objc func updateForParallexProgress() {
        
        
        
        let prallexProgress = self.tableView.parallaxHeader.progress
        printDebug("intial progress value \(prallexProgress)")
        
        printDebug("progress value \(prallexProgress)")
        
        
        if isScrollingFirstTime && prallexProgress > 1.0 {
            maxValue = prallexProgress
            minValue = abs(1 - prallexProgress)
            finalMaxValue = Int(maxValue * 100)
            isScrollingFirstTime = false
            printDebug("minvalue \(minValue) and maxValue \(maxValue)")
        }
//
//
        if minValue...maxValue ~= prallexProgress {
            printDebug("progress value \(prallexProgress)")
            let intValue =  finalMaxValue - Int(prallexProgress * 100)

            printDebug(" int value \(intValue)")
            let newProgress: Float = (Float(1) - (Float(1.3)  * (Float(intValue) / 100)))

            printDebug("new progress value \(newProgress)")


            printDebug("CGFloat progress  Value is \(newProgress.toCGFloat.roundTo(places: 3))")

            self.currentProgressIntValue = intValue
            self.currentProgress = newProgress.toCGFloat
            self.profileImageHeaderView?.profileImageView.transform = CGAffineTransform(scaleX: (CGFloat(newProgress)) , y: (CGFloat(newProgress))).translatedBy(x: 0, y: CGFloat(2200 * (Float(intValue) / 1000)))



        }
//
        if prallexProgress  <= 0.7 {
            if isNavBarHidden {
                self.statusBarStyle = .lightContent
                
                self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                    
                    self?.topNavView.firstRightButton.isSelected = false
                    
                    self?.topNavView.leftButton.isSelected = false
                    
                    self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                    
                    self?.topNavView.navTitleLabel.text = ""
                    
                    self?.topNavView.backView.backgroundColor = AppColors.themeWhite
                    
                }
                
            } else {
                self.statusBarStyle = .default
                
                self.topNavView.animateBackView(isHidden: false) { [weak self](isDone) in
                    
                    self?.topNavView.firstRightButton.isSelected = true
                    
                    self?.topNavView.leftButton.isSelected = true
                    
                    self?.topNavView.leftButton.tintColor = AppColors.themeGreen
                    
                    self?.topNavView.navTitleLabel.text = self?.getUpdatedTitle()
                    
                }
            }
        } else {
            
            self.statusBarStyle = .lightContent
            
            self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                
                self?.topNavView.firstRightButton.isSelected = false
                
                self?.topNavView.leftButton.isSelected = false
                
                self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                
                self?.topNavView.navTitleLabel.text = ""
                
                self?.topNavView.backView.backgroundColor = AppColors.themeWhite
            }
            
        }
        self.isNavBarHidden = false
        //self.profileImageHeaderView?.layoutIfNeeded()
        //
        //self.profileImageHeaderView?.doInitialSetup()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.updateForParallexProgress), with: nil, afterDelay: 0.05)
        //        self.updateForParallexProgress()
    }
    
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        self.updateForParallexProgress()
    //        delay(seconds: 0.3) { [weak self] in
    //            self?.updateForParallexProgress()
    //        }
    //    }
    
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //        self.updateForParallexProgress()
    //    }
    //
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        self.updateForParallexProgress()
    //    }
}

// MARK: - Profile Header view Delegate methods

extension ViewProfileVC: SlideMenuProfileImageHeaderViewDelegate {
    func profileHeaderTapped() {
        //
    }
    
    func profileImageTapped() {
        printDebug("profile Image Tapped View ProfileVc")
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.travellerDetailModel ?? TravelDetailModel(), usingFor: .viewProfile)
    }
}

extension ViewProfileVC: ViewProfileDetailVMDelegate {
    func willGetDetail(_ isShowLoader: Bool) {
        //
        self.profileImageHeaderView?.startLoading()
    }
    
    func willLogOut() {
        //
    }
    
    func didLogOutSuccess() {
        //
        UserInfo.loggedInUserId = nil
        AppFlowManager.default.goToDashboard()
        CoreDataManager.shared.deleteData("TravellerData")
        CoreDataManager.shared.deleteData("BookingData")
        CoreDataManager.shared.deleteData("HotelSearched")
        UserDefaults.removeObject(forKey: UserDefaults.Key.currentUserCookies.rawValue)
        UserDefaults.removeObject(forKey: UserDefaults.Key.xAuthToken.rawValue)
        UserInfo.hotelFilterApplied = nil
    }
    
    func didLogOutFail(errors: ErrorCodes) {
        //
    }
    
    
    
    func getSuccess(_ data: TravelDetailModel) {
        self.profileImageHeaderView?.stopLoading()
        self.viewModel.travelData = data
        
        self.tableView.reloadData()
        
        //self.setupParallaxHeader()
        self.updateUserData()
        self.sendDataChangedNotification(data: ATNotification.profileChanged)
    }
    
    func getFail(errors: ErrorCodes) {
        self.profileImageHeaderView?.stopLoading()
        if AppGlobals.shared.isNetworkRechable() {
            AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
    }
}


