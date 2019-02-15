//
//  ViewProfileDetailVC.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

class ViewProfileDetailVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: ATTableView!
     @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Variables
    
    let viewModel = ViewProfileDetailVM()
    var sections:[String] = [String]()
    var moreInformation: [String] = []
    let contactNumber = [LocalizedString.Mobile]
    let address = [LocalizedString.Address]
    var mobile: [Mobile] = []
    var email: [Email] = []
    var social: [Social] = []
    var addresses: [Address] = []
    var frequentFlyer: [FrequentFlyer] = []
    var informations: [String] = []
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    var passportDetails: [String] = []
    var flightDetails: [String] = []
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    let cellIdentifier = "ViewProfileDetailTableViewCell"
    let multipleDetailCellIdentifier = "ViewProfileMultiDetailTableViewCell"
    var profileImageHeaderView: SlideMenuProfileImageHeaderView = SlideMenuProfileImageHeaderView()
    var travelData: TravelDetailModel?
    
    private var headerViewHeight: CGFloat {
        return UIDevice.isIPhoneX ? 84.0 : 64.0
    }
    
    private let headerHeightToAnimate: CGFloat = 30.0
    private let footterHeight: CGFloat = 35.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
//            self?.profileImageHeaderView.profileImageViewHeightConstraint.constant = 121
//            self?.profileImageHeaderView.layoutIfNeeded()
            self?.view.alpha = 1.0
        }
        doInitialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Api calling
        viewModel.webserviceForGetTravelDetail()
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
        if let noti = note.object as? ATNotification, noti == .profileChanged {
            viewModel.webserviceForGetTravelDetail()
        }
    }
    
    // MARK: - Helper method
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)

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
        
        setupParallaxHeader()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: multipleDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: multipleDetailCellIdentifier)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: footterHeight))
        tableView.tableFooterView = footerView
        profileImageHeaderView.dividerView.isHidden = true
        setUpDataFromApi()
    }
    
    private func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(300.0)//CGFloat(UIDevice.screenHeight * 0.45)

        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 0)
        
        tableView.parallaxHeader.view = profileImageHeaderView
        tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        tableView.parallaxHeader.height = parallexHeaderHeight
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.delegate = self
        
        
      //  profileImageHeaderView.dividerView.isHidden = true
        
        self.view.bringSubviewToFront(self.topNavView)
    }
    
    private func setUpDataFromApi() {
        guard let travel = travelData else {
            return
        }
        profileImageHeaderView.userNameLabel.text = (travel.firstName) + " " + (travel.lastName)
        profileImageHeaderView.emailIdLabel.text = ""
        profileImageHeaderView.mobileNumberLabel.text = ""
        profileImageHeaderView.familyButton.isHidden = false
        profileImageHeaderView.familyButton.setTitle(travel.label.isEmpty ? "Others" : travel.label.capitalizedFirst(), for: .normal)
        profileImageHeaderView.layoutIfNeeded()
        
        var placeImage = AppPlaceholderImage.profile
        
        placeImage = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, font: AppFonts.Regular.withSize(35.0))
        if travel.profileImage != "" {
            profileImageHeaderView.profileImageView.setImageWithUrl(travel.profileImage, placeholder: placeImage, showIndicator: false)
            profileImageHeaderView.backgroundImageView.setImageWithUrl(travel.profileImage, placeholder: placeImage, showIndicator: false)
            profileImageHeaderView.blurEffectView.alpha = 1.0
        } else {
            if viewModel.currentlyUsingFor == .travellerList {
                profileImageHeaderView.profileImageView.image = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, font: AppFonts.Regular.withSize(35.0))
                profileImageHeaderView.backgroundImageView.image = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, textColor: AppColors.themeBlack)
                profileImageHeaderView.blurEffectView.alpha = 1.0
            } else {
                profileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppFonts.Regular.withSize(35.0))
                profileImageHeaderView.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(textColor: AppColors.themeBlack).blur
                profileImageHeaderView.blurEffectView.alpha = 0.0
            }
        }

        mobile.removeAll()
        let tempMobile = travel.contact.mobile.filter { (mbl) -> Bool in
            !mbl.value.isEmpty
        }
        mobile.append(contentsOf: tempMobile)
        
        if travel.address.count > 0 {
            addresses = travel.address
            sections.append(LocalizedString.Address.localized)
        }
        
        let tempEmail = travel.contact.email.filter { (eml) -> Bool in
            !eml.value.isEmpty
        }
        email.append(contentsOf: tempEmail)
        
        let social = travel.contact.social.filter { (scl) -> Bool in
            !scl.value.isEmpty
        }
        sections.removeAll()
        if email.count > 0 {
            sections.append(LocalizedString.EmailAddress.localized)
        }
        if mobile.count > 0 {
            sections.append(LocalizedString.ContactNumber.localized)
        }
        if social.count > 0 {
            self.social = social
            sections.append(LocalizedString.SocialAccounts.localized)
        }
        
        informations.removeAll()
        if !travel.dob.isEmpty {
            informations.append(AppGlobals.shared.formattedDateFromString(dateString: travel.dob, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
            moreInformation.append(LocalizedString.Birthday.localized)
        }
        if !travel.doa.isEmpty {
            informations.append(AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
            moreInformation.append(LocalizedString.Anniversary.localized)
        }
        if !travel.notes.isEmpty {
            informations.append(travel.notes)
            moreInformation.append(LocalizedString.Notes.localized)
        }
        if informations.count > 0 {
            sections.append(LocalizedString.MoreInformation.localized)
        }
        passportDetails.removeAll()
        if travel.passportNumber != "" {
            passportDetails.append((travel.passportNumber))
            passportDetails.append((travel.passportCountryName))
            sections.append(LocalizedString.PassportDetails.localized)
        }
        
        if travel.preferences.seat.value != "" || travel.preferences.meal.value != "" {
            let seatPreference = (travel.preferences.seat.value)
            let mealPreference = (travel.preferences.meal.value)
            flightDetails.append(seatPreference)
            flightDetails.append(mealPreference)
            sections.append(LocalizedString.FlightPreferences.localized)
        }
        
        let frequentFlyer = travel.frequestFlyer
        if frequentFlyer.count > 0 {
            self.frequentFlyer = frequentFlyer
        }
        tableView.reloadData()
    }
    
    func getProgressiveHeight(forProgress: CGFloat) -> CGFloat {
        let ratio: CGFloat = headerHeightToAnimate / CGFloat(0.5)
        return headerHeightToAnimate - (forProgress * ratio)
    }
    
}

extension ViewProfileDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToEditProfileVC(travelData: travelData, usingFor: .viewProfile)
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension ViewProfileDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.EmailAddress.localized:
            return email.count
        case LocalizedString.MoreInformation.localized:
            return informations.count
        case LocalizedString.ContactNumber.localized:
            return mobile.count
        case LocalizedString.SocialAccounts.localized:
            return social.count
        case LocalizedString.Address.localized:
            return addresses.count
        case LocalizedString.PassportDetails.localized:
            return 3
        case LocalizedString.FlightPreferences.localized:
            if frequentFlyer.count > 0 {
                return 2 + frequentFlyer.count
            } else {
                return 2
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewProfileDetailTableViewCell else {
            fatalError("ViewProfileDetailTableViewCell not found")
        }
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress.localized:
            cell.configureCell(email[indexPath.row].label, email[indexPath.row].value)
            cell.separatorView.isHidden = (indexPath.row + 1 == email.count) ? true : false
            return cell
        case LocalizedString.MoreInformation.localized:
            cell.configureCell(moreInformation[indexPath.row], informations[indexPath.row])
            cell.separatorView.isHidden = (indexPath.row + 1 == informations.count) ? true : false
            return cell
        case LocalizedString.ContactNumber.localized:
            var contact = ""
            if !mobile[indexPath.row].isd.isEmpty {
                contact = "\(mobile[indexPath.row].isd) \(mobile[indexPath.row].value)"
            }
            else {
                contact = mobile[indexPath.row].value
            }
            cell.configureCell(mobile[indexPath.row].label, contact.removeAllWhiteSpacesAndNewLines)
            cell.separatorView.isHidden = (indexPath.row + 1 == mobile.count) ? true : false
            return cell
        case LocalizedString.SocialAccounts.localized:
            cell.configureCell(social[indexPath.row].label, social[indexPath.row].value)
            cell.separatorView.isHidden = (indexPath.row + 1 == social.count) ? true : false
            return cell
        case LocalizedString.Address.localized:
            let content = addresses[indexPath.row].line2 + "\n" + addresses[indexPath.row].line1
            cell.configureCell(addresses[indexPath.row].label, content)
            cell.separatorView.isHidden = (indexPath.row + 1 == addresses.count) ? true : false
            return cell
        case LocalizedString.PassportDetails.localized:
            
            if indexPath.row >= 2 {
                guard let viewProfileMultiDetailcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                    fatalError("ViewProfileMultiDetailTableViewCell not found")
                }
                viewProfileMultiDetailcell.frequentFlyerView.isHidden = true
                if let issueDate = travelData?.passportIssueDate, let expiryDate = travelData?.passportExpiryDate {
                    viewProfileMultiDetailcell.cofigureCell(AppGlobals.shared.formattedDateFromString(dateString: issueDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "", AppGlobals.shared.formattedDateFromString(dateString: expiryDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
                }
                viewProfileMultiDetailcell.separatorView.isHidden = true
                return viewProfileMultiDetailcell
                
            } else {
                cell.configureCell(passportDetaitTitle[indexPath.row], passportDetails[indexPath.row])
                return cell
            }
        case LocalizedString.FlightPreferences.localized:
            if indexPath.row >= 2 {
                guard let viewProfileMultiDetailcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                    fatalError("ViewProfileMultiDetailTableViewCell not found")
                }
                viewProfileMultiDetailcell.secondTitleLabel.isHidden = true
                viewProfileMultiDetailcell.configureCellForFrequentFlyer(indexPath, frequentFlyer[indexPath.row - 2].logoUrl, frequentFlyer[indexPath.row - 2].airlineName, frequentFlyer[indexPath.row - 2].number)
                
                viewProfileMultiDetailcell.separatorLeadingConstraint.constant = ((indexPath.row-1) == frequentFlyer.count) ? 0.0 : 16.0
                return viewProfileMultiDetailcell
                
            } else {
                cell.configureCell(flightPreferencesTitle[indexPath.row], flightDetails[indexPath.row])
                cell.sepratorLeadingConstraint.constant = frequentFlyer.isEmpty ? 0.0 : 16.0
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.headerLabel.text = sections[section].localized
        return headerView
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension ViewProfileDetailVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        printDebug("progress %f \(parallaxHeader.progress)")
        
        if parallaxHeader.progress >= 0.6 {
            profileImageHeaderView.profileImageViewHeightConstraint.constant = 121 * parallaxHeader.progress
        }
        
        if parallaxHeader.progress <= 0.5 {
            
            self.topNavView.animateBackView(isHidden: false)

            UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
                self?.topNavView.firstRightButton.isSelected = true
                self?.topNavView.leftButton.isSelected = true
                self?.topNavView.leftButton.tintColor = AppColors.themeGreen
                printDebug(parallaxHeader.progress)
                
                self?.topNavView.navTitleLabel.text = self?.profileImageHeaderView.userNameLabel.text
            }
        } else {
            self.topNavView.animateBackView(isHidden: true)
            self.topNavView.firstRightButton.isSelected = false
            self.topNavView.leftButton.isSelected = false
            self.topNavView.leftButton.tintColor = AppColors.themeWhite
            self.topNavView.navTitleLabel.text = ""
        }
        profileImageHeaderView.layoutIfNeeded()
        profileImageHeaderView.doInitialSetup()
    }
}

extension ViewProfileDetailVC: ViewProfileDetailVMDelegate {
    func willLogOut() {
        //
    }
    
    func didLogOutSuccess() {
        //
    }
    
    func didLogOutFail(errors: ErrorCodes) {
        //
    }
    
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        travelData = data
        setUpDataFromApi()
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}
