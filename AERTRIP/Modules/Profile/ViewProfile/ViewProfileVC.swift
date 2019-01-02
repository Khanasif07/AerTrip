//
//  ViewProfileVC.swift
//  AERTRIP
//
//  Created by apple on 18/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

class ViewProfileVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var drawableHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var drawableHeaderView: UIView!
    
    // MARK: - Variables
    
    let cellIdentifier = "ViewProfileTableViewCell"
    var sections = ["details", "accounts", "logOut"]
    var details = [LocalizedString.TravellerList, LocalizedString.HotelPreferences, LocalizedString.QuickPay, LocalizedString.LinkedAccounts, LocalizedString.NewsLetters]
    var accounts = [LocalizedString.Settings, LocalizedString.Notification]
    var logOut = [LocalizedString.LogOut]
    var profileImageHeaderView: SlideMenuProfileImageHeaderView = SlideMenuProfileImageHeaderView()
    let viewModel = ViewProfileDetailVM()
    var travelData: TravelDetailModel?
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(self)
        self.profileImageHeaderView.delegate = self
    
        self.view.alpha = 0.5
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tableView.origin.x = -200
            self?.profileImageHeaderView.profileImageViewHeightConstraint.constant = 121
            self?.profileImageHeaderView.layoutIfNeeded()
            self?.view.alpha = 1.0
        }
        self.doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.webserviceForGetTravelDetail()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            self.tableView.tableHeaderView = headerView
            self.tableView.layoutIfNeeded()
        }
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.parallaxHeader.minimumHeight = topLayoutGuide.length
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IB Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        self.profileImageHeaderView.delegate = self
        // addTableHeaderView()
        self.setupParallaxHeader()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        tableView.tableFooterView = footerView
        self.tableView.dataSource = self
        self.tableView.delegate   = self
    }
    
    func addTableHeaderView() {
        let profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(self)
        let gradient = CAGradientLayer()
        
        gradient.frame = profileImageHeaderView.bounds
        gradient.colors = [AppColors.viewProfileTopGradient.color.cgColor, UIColor.white.cgColor]
        let HEADER_HEIGHT = 319
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        self.view.bringSubviewToFront(headerView)
        profileImageHeaderView.layer.insertSublayer(gradient, at: 0)
        tableView.tableHeaderView = profileImageHeaderView
    }
    
    private func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(319) // UIScreen.width * 9 / 16 + 55
        
        let parallexHeaderMinHeight = self.navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: parallexHeaderHeight)
        
        self.tableView.parallaxHeader.view = profileImageHeaderView
        self.tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        self.tableView.parallaxHeader.height = parallexHeaderHeight
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.tableView.parallaxHeader.delegate = self
        
        self.profileImageHeaderView.userNameLabel.text = UserInfo.loggedInUser?.profileName ?? LocalizedString.na.localized
        self.profileImageHeaderView.emailIdLabel.text = UserInfo.loggedInUser?.email ?? LocalizedString.na.localized
        self.profileImageHeaderView.mobileNumberLabel.text = UserInfo.loggedInUser?.mobile ?? LocalizedString.na.localized
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            self.profileImageHeaderView.profileImageView.kf.setImage(with: URL(string: imagePath))
        }
        else {
            profileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            profileImageHeaderView.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
        }
        
        self.view.bringSubviewToFront(self.headerView)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate Methods

extension ViewProfileVC : UITableViewDataSource, UITableViewDelegate {

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewProfileTableViewCell else {
            fatalError("ViewProfileTableViewCell not found")
        }
        switch self.sections[indexPath.section] {
        case "details":
            cell.separatorView.isHidden = true
            cell.configureCell(self.details[indexPath.row].rawValue)
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
        
        switch sections[indexPath.section] {
            
        case "details":
            
            switch indexPath.row {
                
            case 1:
                
                AppFlowManager.default.moveToHotelPreferencesVC()
                
            default:
                break
            }
            
        case "logOut":
            
            let _ =   AKAlertController.actionSheet( nil, message: LocalizedString.DoYouWantToLogout.localized, sourceView: self.view, buttons: [LocalizedString.Logout.localized], tapBlock: {(alert,index) in
                
                if index == 0 {
                    UserInfo.loggedInUserId = nil
                    AppFlowManager.default.goToDashboard()
                }
            })
            
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
            self.profileImageHeaderView.profileImageViewHeightConstraint.constant = 120 * parallaxHeader.progress
        }
        
        if parallaxHeader.progress <= 0.5 {
            UIView.animate(withDuration: 0.5) { [weak self] in
                // self?.view.bringSubviewToFront((self?.headerView)!)
                
                self?.headerView.backgroundColor = UIColor.white
//                self?.drawableHeaderViewHeightConstraint.constant = 44
//                self?.drawableHeaderView.backgroundColor = UIColor.white
                
                self?.editButton.setTitleColor(AppColors.themeGreen, for: .normal)
                
                // self?.view.bringSubviewToFront((self?.drawableHeaderView)!)
                
                let backImage = UIImage(named: "Back")
                let tintedImage = backImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self?.backButton.setImage(tintedImage, for: .normal)
                self?.backButton.tintColor = AppColors.themeGreen
                print(parallaxHeader.progress)
                
                self?.headerLabel.text = self?.profileImageHeaderView.userNameLabel.text
            }
        } else {
            self.drawableHeaderView.backgroundColor = UIColor.clear
            self.drawableHeaderViewHeightConstraint.constant = 0
            self.headerView.backgroundColor = UIColor.clear
            self.editButton.setTitleColor(UIColor.white, for: .normal)
            self.backButton.tintColor = UIColor.white
            self.headerLabel.text = ""
        }
        self.profileImageHeaderView.layoutIfNeeded()
        self.profileImageHeaderView.doInitialSetup()
    }
}

// MARK: - Profile Header view Delegate methods

extension ViewProfileVC: SlideMenuProfileImageHeaderViewDelegate {
    func profileHeaderTapped() {
        //
    }
    
    func profileImageTapped() {
        NSLog("profile Image Tapped View ProfileVc")
        AppFlowManager.default.moveToViewProfileDetailVC()
    }
}

extension ViewProfileVC: ViewProfileDetailVMDelegate {
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        self.travelData = data
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}
