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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
    private var isBackBtnTapped = false
    
    weak var delegate: ViewProfileVCDelegate?
    let cellIdentifier = "ViewProfileTableViewCell"
    let viewProfileFooterView = "ViewProfileFooterView"
    var sections = ["details", "logOut"]
    var details = [LocalizedString.TravellerList.localized, LocalizedString.HotelPreferences.localized,  LocalizedString.QuickPay.localized,  LocalizedString.LinkedAccounts.localized, LocalizedString.AccountDetails.localized]
    var logOut = [LocalizedString.Settings,  LocalizedString.LogOut]
    //[LocalizedString.ChangePassword, LocalizedString.changeMobileNumber, LocalizedString.disableWalletOtp, LocalizedString.LogOut]
    var profileImageHeaderView: SlideMenuProfileImageHeaderView?
    
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
        self.profileImageHeaderView?.profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
        //        self.profileImageHeaderView?.profileImageViewBottomConstraint.constant = 18
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
        }
        self.doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let main = AppFlowManager.default.mainHomeVC, main.isPushedToNext {
            //self.statusBarStyle = topNavView.backView.isHidden ? .default : .lightContent
            self.updateForParallexProgress()
        }
        else if let sideMenu = AppFlowManager.default.sideMenuController, !sideMenu.isOpen {
            self.statusBarStyle = .lightContent
        }
        else {
            self.statusBarStyle = .darkContent
        }
        
        // self.topNavView.backgroundType = .blurAnimatedView(isDark: false)
        DispatchQueue.backgroundAsync() { [weak self] in
            self?.viewModel.webserviceForGetTravelDetail()
        }
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.profileImageHeaderView?.delegate = self
        self.profileImageHeaderView?.isHidden = false
        profileImageHeaderView?.makeImageCircular()
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
//        if let noti = note.object as? ATNotification, noti == .profileSavedOnServer {
            // self.viewModel.webserviceForGetTravelDetail()
//        }
    }
    
    
    
    // MARK: - Helper Methods
    
    func doInitialSetup() {
        
        self.activityIndicator.color = AppColors.themeGreen
        self.activityIndicator.isHidden = true
        self.view.backgroundColor = AppColors.themeWhite
        self.topNavView.backgroundColor = AppColors.clear
        self.headerViewHeightConstraint.constant = headerViewHeight
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        tableView.register(UINib(nibName: viewProfileFooterView, bundle: nil), forHeaderFooterViewReuseIdentifier: viewProfileFooterView)

        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        
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
        
        //let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 17.0))
        //tableView.tableFooterView = footerView
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.bounces = true
    }
    
    func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(301.0)//CGFloat(UIDevice.screenHeight * 0.45)
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
            self.profileImageHeaderView?.profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
            self.profileImageHeaderView?.blurEffectView.alpha = 1.0
        } else {
            
            self.profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            self.profileImageHeaderView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppConstants.profileViewBackgroundNameIntialsFont, textColor: AppColors.themeBlack).blur
            self.profileImageHeaderView?.blurEffectView.alpha = 0.0
            self.profileImageHeaderView?.profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
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
        if viewModel.isComingFromDeepLink {
            navigationController?.popViewController(animated: true)
            return
        }
        isBackBtnTapped = true
        self.delegate?.backButtonAction(sender)
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.topNavView.firstRightButton.isHidden = true
        self.activityIndicator.startAnimating()
        if self.viewModel.travelData == nil {
            self.viewModel.travelData = UserInfo.loggedInUser?.travellerDetailModel
        }
        //        self.topNavView.configureFirstRightButton( normalTitle: "", selectedTitle: "")
        //        self.topNavView.isToShowIndicatorView = true
        //        self.topNavView.startActivityIndicaorLoading()
        AppFlowManager.default.moveToEditProfileVC(travelData: self.viewModel.travelData, usingFor: .viewProfile)
        delay(seconds: 0.5) { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.topNavView.firstRightButton.isHidden = false
            // self?.topNavView.stopActivityIndicaorLoading()
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
        case "logOut":
            return self.logOut.count
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return 79.0
        } else if indexPath.row == self.details.count - 1 && indexPath.section == 0 {
            return 79.0
        }
        else {
            return 61.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewProfileTableViewCell else {
            fatalError("ViewProfileTableViewCell not found")
        }
        cell.selectionStyle = .gray
        if indexPath.row != 0 {
            cell.topViewHeightConst.constant = 0
        } else {
            cell.topViewHeightConst.constant = 19
        }
        switch self.sections[indexPath.section] {
        case "details":
            cell.bottomViewHeightConst.constant =  indexPath.row == self.details.count - 1 ? 18 : 0
            cell.separatorView.isHidden = self.details[indexPath.row] != LocalizedString.AccountDetails.localized
            cell.menuOptionLabel.isHidden = false
            cell.configureCell(self.details[indexPath.row])
            cell.contentView.layoutIfNeeded()
            return cell
        case "logOut":
            cell.bottomViewHeightConst.constant =  0
            cell.separatorView.isHidden = true
            switch self.logOut[indexPath.row]{
            case LocalizedString.ChangePassword:
                let title = (UserInfo.loggedInUser?.hasPassword == true) ? LocalizedString.ChangePassword.localized : LocalizedString.Set_password.localized
                cell.configureCell(title)
//            case LocalizedString.changeMobileNumber:
//                let title = (UserInfo.loggedInUser?.mobile != "" ) ? LocalizedString.changeMobileNumber.localized : LocalizedString.setMobileNumner.localized
//                cell.configureCell(title)
//            case LocalizedString.disableWalletOtp:
//                let title = (UserInfo.loggedInUser?.isWalletEnable == true) ? "Disable Wallet OTP" : "Enable Wallet OTP"
//                cell.configureCell(title)
            default: cell.configureCell(self.logOut[indexPath.row].localized)
            
            }
            
//            if self.logOut[indexPath.row].localized == LocalizedString.ChangePassword.localized {
//                let title = (UserInfo.loggedInUser?.hasPassword == true) ? LocalizedString.ChangePassword.localized : LocalizedString.Set_password.localized
//                cell.configureCell(title)
//            } else if self.logOut[indexPath.row].localized == LocalizedString.changeMobileNumber.localized{
//                let title = (UserInfo.loggedInUser?.mobile != "" ) ? LocalizedString.changeMobileNumber.localized : LocalizedString.setMobileNumner.localized
//                cell.configureCell(title)
//            }else{
//                cell.configureCell(self.logOut[indexPath.row].localized)
//            }
            cell.contentView.layoutIfNeeded()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.sections[indexPath.section] {
       
            case "details":
                self.statusBarStyle = .darkContent
                    switch self.details[indexPath.row] {
            // Open traveller detail listing
                    case LocalizedString.TravellerList.localized:
                        AppFlowManager.default.moveToTravellerListVC()
                
                    // Open View All hotel details
                    case LocalizedString.HotelPreferences.localized:
                        AppFlowManager.default.moveToViewAllHotelsVC()
                
                    // Open Quick pay
                    case LocalizedString.QuickPay.localized:
                        AppFlowManager.default.moveToQuickPayVC()
                
                    // Open linked accout VC
                    case LocalizedString.LinkedAccounts.localized:
                        AppFlowManager.default.moveToLinkedAccountsVC()
                
                    case LocalizedString.AccountDetails.localized:
//                        AppToast.default.showToastMessage(message: "This feature is coming soon")
                    
                        AppFlowManager.default.moveToAccountDetailsVC()

//                        self.openUpdateAccount()
                        
                    default:
                        AppToast.default.showToastMessage(message: "This feature is coming soon")
                        break
                }
            
            //        case "accounts":
            //            self.statusBarStyle = .default
            //            if indexPath.row == 0 {
            //                //settings
            //                AppFlowManager.default.moveToSettingsVC()
            //            } else {
            //                AppFlowManager.default.moveToNotificationVC()
            //            }
        //
        case "logOut":
            switch self.logOut[indexPath.row] {
             case LocalizedString.ChangePassword
                :
                AppFlowManager.default.moveToChangePasswordVC(type: (UserInfo.loggedInUser?.hasPassword == true) ? .changePassword : .setPassword, delegate: self)
                
            // show logout option
//            case LocalizedString.changeMobileNumber: self.changeMobileNumber()
//            case LocalizedString.disableWalletOtp: self.enableDisableOtp()
            case LocalizedString.LogOut:
                let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.LogOut.localized], colors: [AppColors.themeRed])
                _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.DoYouWantToLogout.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                    
                    if index == 0 {
                        self.viewModel.webserviceForLogOut()
                    }
                }
            case LocalizedString.Settings: AppFlowManager.default.moveToSettingsVC()
                
            default:
                AppToast.default.showToastMessage(message: "This feature is coming soon")
                break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 227 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewProfileFooterView) as? ViewProfileFooterView else {return nil}
            return footerView
        }
            return nil
    }
    
   
    
//    func changeMobileNumber(){
//        if (UserInfo.loggedInUser?.mobile.isEmpty ?? false){
//            if (UserInfo.loggedInUser?.hasPassword == true){
//                let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
//                vc.modalPresentationStyle = .overFullScreen
//        //        vc.viewModel.itId = self.viewModel.appliedCouponData.itinerary.id
//                vc.viewModel.varificationType = .setMobileNumber
//                vc.delegate = self
//                self.present(vc, animated: true, completion: nil)
//            }else{
//                AppToast.default.showToastMessage(message: "Please set your account password!")
//            }
//
//        }else{
//            let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
//            vc.modalPresentationStyle = .overFullScreen
//    //        vc.viewModel.itId = self.viewModel.appliedCouponData.itinerary.id
//            vc.viewModel.varificationType = .phoneNumberChangeOtp
//            vc.delegate = self
//            self.present(vc, animated: true, completion: nil)
//        }
//
//    }
    
//    func enableDisableOtp(){
//        let vc = EnableDisableWalletOTPVC.instantiate(fromAppStoryboard: .OTPAndVarification)
//        vc.modalPresentationStyle = .overFullScreen
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
//    }
    
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
            
        }
        //
        if prallexProgress  <= 0.7 {
            if isNavBarHidden {
                if let parent = self.parent as? BaseVC {
                    parent.statusBarStyle = .lightContent
                }
                
                self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                    
                    self?.topNavView.firstRightButton.isSelected = false
                    
                    self?.topNavView.leftButton.isSelected = false
                    
                    self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                    
                    self?.topNavView.navTitleLabel.text = ""
                    
                    self?.topNavView.backView.backgroundColor = .clear//AppColors.themeWhite
                    
                    self?.topNavView.backgroundColor = .clear
                }
                
            } else {
                if let parent = self.parent as? BaseVC {
                    parent.statusBarStyle = .darkContent
                }
                
                self.topNavView.animateBackView(isHidden: false) { [weak self](isDone) in
                    
                    self?.topNavView.firstRightButton.isSelected = true
                    
                    self?.topNavView.leftButton.isSelected = true
                    
                    self?.topNavView.leftButton.tintColor = AppColors.themeGreen
                    
                    self?.topNavView.navTitleLabel.text = self?.getUpdatedTitle()
                    
                }
            }
        } else {
            if navigationController?.viewControllers.last is FlightResultBaseViewController {
                
            } else if let parent = self.parent as? BaseVC {
                parent.statusBarStyle = isBackBtnTapped ? .darkContent : .lightContent
            }
            
            self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                
                self?.topNavView.firstRightButton.isSelected = false
                
                self?.topNavView.leftButton.isSelected = false
                
                self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                
                self?.topNavView.navTitleLabel.text = ""
                
                self?.topNavView.backView.backgroundColor = .clear//AppColors.themeWhite
                self?.topNavView.backgroundColor = .clear
            }
            
        }
        self.isNavBarHidden = false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
        
        // Nimish
        updateProfileImageViewFrame()
        // Nimish
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.updateForParallexProgress), with: nil, afterDelay: 0.05)
        //        self.updateForParallexProgress()
    }
    func updateProfileImageViewFrame(){
        guard profileImageHeaderView != nil else {return}
        profileImageHeaderView!.profileImageView.layer.cornerRadius = profileImageHeaderView!.profileImageView.frame.size.width / 2
    }
    
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
        FacebookController.shared.facebookLogout()
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
            if !((UserInfo.loggedInUser?.userCreditType ?? UserCreditType.statement) == .topup){
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
        }
    }
}

extension ViewProfileVC: ChangePasswordVCDelegate{//, OtpConfirmationDelegate, WalletEnableDisableDelegate {
//    func otpValidationCompleted(_ isSuccess: Bool) {
//        self.updateUserData()
//        self.tableView.reloadData()
//    }
//
//    func otpEnableDisableCompleted(_ isSuccess: Bool){
//        self.tableView.reloadData()
//    }
//
    func passowordChangedSuccessFully() {
        self.tableView.reloadData()
    }
    
}

