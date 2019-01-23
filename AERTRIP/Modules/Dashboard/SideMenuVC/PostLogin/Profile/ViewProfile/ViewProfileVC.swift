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
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var drawableHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var drawableHeaderView: UIView!
    
    // MARK: - Variables
    
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
    var travelData: TravelDetailModel?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        self.profileImageHeaderView?.delegate = self
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
            
        }
        self.doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    // MARK: - IB Actions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.delegate?.backButtonAction(sender)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.travelData = self.travelData
        self.navigationController?.pushViewController(ob, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func doInitialSetup() {
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.editButton.setTitle(LocalizedString.Edit.rawValue, for: .normal)
        self.profileImageHeaderView?.delegate = self
        self.setupParallaxHeader()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        tableView.tableFooterView = footerView
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(UIDevice.screenHeight * 0.45) // UIScreen.width * 9 / 16 + 55
        
        let parallexHeaderMinHeight = self.navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView?.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 0.0)
        
        self.tableView.parallaxHeader.view = profileImageHeaderView
        self.tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        self.tableView.parallaxHeader.height = parallexHeaderHeight
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.tableView.parallaxHeader.delegate = self
        
        self.profileImageHeaderView?.userNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized)"
        self.profileImageHeaderView?.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        if let mobileNumber = UserInfo.loggedInUser?.mobile ,let isd = UserInfo.loggedInUser?.isd {
             self.profileImageHeaderView?.mobileNumberLabel.text = "\(isd) \(mobileNumber)"
        }
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            self.profileImageHeaderView?.profileImageView.kf.setImage(with: URL(string: imagePath))
            self.profileImageHeaderView?.backgroundImageView.kf.setImage(with: URL(string: imagePath))
            //addBlurToImage()
        }
        else {
            profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            profileImageHeaderView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
        
        self.view.bringSubviewToFront(self.headerView)
    }
    
    func deSetupParallaxHeader() {
        self.profileImageHeaderView?.translatesAutoresizingMaskIntoConstraints = true
        self.profileImageHeaderView?.removeFromSuperview()
        self.tableView.parallaxHeader.view = nil
        self.profileImageHeaderView?.layoutIfNeeded()
    }
    
    func addBlurToImage() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            profileImageHeaderView?.backgroundImageView.addSubview(blurEffectView)
        } else {
            self.view.backgroundColor = .black
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
        return 75.0
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
                
                AppFlowManager.default.moveToTravellerListVC()
                
            case 1:
                
                AppFlowManager.default.moveToViewAllHotelsVC()
                
            case 3:
                
                AppFlowManager.default.moveToLinkedAccountsVC()
                
            default:
                break
            }
            
        case "logOut":
            
            let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.LogOut.localized], colors: [AppColors.themeRed])
            _ = PKAlertController.default.presentActionSheet(nil, message: LocalizedString.DoYouWantToLogout.localized, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
                
                if index == 0 {
                    UserInfo.loggedInUserId = nil
                    AppFlowManager.default.goToDashboard()
                    CoreDataManager.shared.deleteCompleteDB()
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension ViewProfileVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
        
        if parallaxHeader.progress >= 0.6 {
            self.profileImageHeaderView?.profileImageViewHeightConstraint.constant = 121 * parallaxHeader.progress
        }
        
        if parallaxHeader.progress <= 0.5 {
            UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
                self?.headerView.backgroundColor = UIColor.white
                self?.editButton.setTitleColor(AppColors.themeGreen, for: .normal)
                let backImage = UIImage(named: "Back")
                let tintedImage = backImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self?.backButton.setImage(tintedImage, for: .normal)
                self?.backButton.tintColor = AppColors.themeGreen
                print(parallaxHeader.progress)
                
                self?.headerLabel.text = self?.profileImageHeaderView?.userNameLabel.text
            }
        } else {
            self.drawableHeaderView.backgroundColor = UIColor.clear
            self.drawableHeaderViewHeightConstraint.constant = 0
            self.headerView.backgroundColor = UIColor.clear
            self.editButton.setTitleColor(UIColor.white, for: .normal)
            self.backButton.tintColor = UIColor.white
            self.headerLabel.text = ""
        }
        self.profileImageHeaderView?.layoutIfNeeded()
        self.profileImageHeaderView?.doInitialSetup()
    }
}

// MARK: - Profile Header view Delegate methods

extension ViewProfileVC: SlideMenuProfileImageHeaderViewDelegate {
    func profileHeaderTapped() {
        //
    }
    
    func profileImageTapped() {
        NSLog("profile Image Tapped View ProfileVc")
        AppFlowManager.default.moveToViewProfileDetailVC(UserInfo.loggedInUser?.paxId ?? "", false)
    }
}

extension ViewProfileVC: ViewProfileDetailVMDelegate {
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        self.travelData = data
        self.tableView.reloadData()
        self.setupParallaxHeader()
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}
