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
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
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
    var flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    var passportDetails: [String] = []
    var flightDetails: [String] = []
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    let cellIdentifier = "ViewProfileDetailTableViewCell"
    let multipleDetailCellIdentifier = "ViewProfileMultiDetailTableViewCell"
    var profileImageHeaderView: SlideMenuProfileImageHeaderView?
    var travelData: TravelDetailModel?
    
    private var headerViewHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    private var isNavBarHidden: Bool = true
    private let headerHeightToAnimate: CGFloat = 30.0
    private let footterHeight: CGFloat = 35.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)
        //        profileImageHeaderView?.profileImageViewBottomConstraint?.constant = 16
        profileImageHeaderView?.currentlyUsingAs = .profileDetails
        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
            if self?.viewModel.currentlyUsingFor != .travellerList {
                self?.profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppFonts.Regular.withSize(35.0))
            } else if self?.viewModel.currentlyUsingFor == .travellerList{
                self?.profileImageHeaderView?.profileImageView.image = AppGlobals.shared.getImageFor(firstName: self?.viewModel.travelData?.firstName, lastName: self?.viewModel.travelData?.lastName, font: AppFonts.Regular.withSize(35.0))  
            }
            self?.profileImageHeaderView?.profileImageViewHeightConstraint.constant = 127.0
            self?.profileImageHeaderView?.layoutIfNeeded()
            self?.view.alpha = 1.0
        }
        doInitialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Api calling
        viewModel.webserviceForGetTravelDetail()
        self.statusBarStyle = topNavView.backView.isHidden ? .lightContent : .default
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func dataChanged(_ note: Notification) {
//        if let noti = note.object as? ATNotification, noti == .profileSavedOnServer {
           // viewModel.webserviceForGetTravelDetail(isShowLoader: true)
//        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        delay(seconds: 0.5) { [weak self] in
            self?.topNavView.stopActivityIndicaorLoading()
            self?.topNavView.isToShowIndicatorView = false
        }
        self.topNavView.configureFirstRightButton( normalTitle: LocalizedString.Edit.localized, selectedTitle: LocalizedString.Edit.localized, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
    }
    
    // MARK: - Helper method
    
    func doInitialSetUp() {
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        
        self.headerViewHeightConstraint.constant = headerViewHeight
        
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false, backgroundType: .clear)
        
        let editTitle = "\(LocalizedString.Edit.localized) "
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: editTitle, selectedTitle: editTitle, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: editTitle, selectedTitle: editTitle, normalColor: AppColors.themeWhite, selectedColor: AppColors.themeGreen)
        
        
        let tintedImage = #imageLiteral(resourceName: "Back").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.topNavView.leftButton.setImage(tintedImage, for: .normal)
        self.topNavView.leftButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.topNavView.leftButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.leftButton.isSelected = false
        
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.topNavView.firstRightButton.isSelected = false
        self.topNavView.clipsToBounds = true
        setupParallaxHeader()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: "ViewProfileDetailFrequentCell",bundle: nil), forCellReuseIdentifier: "ViewProfileDetailFrequentCell")
        tableView.register(UINib(nibName: multipleDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: multipleDetailCellIdentifier)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: footterHeight))
        tableView.tableFooterView = footerView
//        profileImageHeaderView?.dividerView.isHidden = true
        setUpDataFromApi()
    }
    
    private func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(293)//CGFloat(UIDevice.screenHeight * 0.45)
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView?.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 0)
        profileImageHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.parallaxHeader.view = profileImageHeaderView
        tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        tableView.parallaxHeader.height = parallexHeaderHeight
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.profileImageHeaderView?.widthAnchor.constraint(equalToConstant: tableView?.width ?? 0.0).isActive = true
        tableView.parallaxHeader.delegate = self
    }
    
    private func setUpDataFromApi() {
        guard let travel = travelData else {
            return
        }
        
        sections.removeAll()
        
        profileImageHeaderView?.userNameLabel.text = (travel.firstName) + " " + (travel.lastName)
        profileImageHeaderView?.emailIdLabel.text = ""
        profileImageHeaderView?.mobileNumberLabel.text = ""
        profileImageHeaderView?.familyButton.isHidden = false
        profileImageHeaderView?.familyButton.setTitle(travel.label.isEmpty ? LocalizedString.Others.localized : travel.label.capitalizedFirst(), for: .normal)
        profileImageHeaderView?.layoutIfNeeded()
        
        var placeImage = AppPlaceholderImage.profile
        
        placeImage = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, font: AppConstants.profileViewBackgroundNameIntialsFont)
        if travel.profileImage != "" {
            profileImageHeaderView?.profileImageView.setImageWithUrl(travel.profileImage, placeholder: placeImage, showIndicator: false)
            profileImageHeaderView?.backgroundImageView.setImageWithUrl(travel.profileImage, placeholder: placeImage, showIndicator: false)
            profileImageHeaderView?.blurEffectView.alpha = 1.0
        } else {
            if viewModel.currentlyUsingFor == .travellerList {
                profileImageHeaderView?.profileImageView.image = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, font: AppFonts.Regular.withSize(35.0))
                profileImageHeaderView?.backgroundImageView.image = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, textColor: AppColors.themeBlack)
                profileImageHeaderView?.blurEffectView.alpha = 1.0
            } else {
                profileImageHeaderView?.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(font: AppFonts.Regular.withSize(35.0))
                profileImageHeaderView?.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder(textColor: AppColors.themeBlack).blur
                profileImageHeaderView?.blurEffectView.alpha = 0.0
            }
        }
        
        email.removeAll()
        var tempEmail = travel.contact.email.filter { (eml) -> Bool in
            !eml.value.isEmpty
        }
//        if let defEmail = UserInfo.loggedInUser?.email, tempEmail.filter({ $0.label == LocalizedString.Default.localized }).isEmpty {
//            let defaultEmail = Email(label: LocalizedString.Default.localized, value: defEmail)
//            tempEmail.append(defaultEmail)
//        }
        
        tempEmail.sort(by: { $0.label < $1.label })
        email.append(contentsOf: tempEmail)
        
        let social = travel.contact.social.filter { (scl) -> Bool in
            !scl.value.isEmpty
        }
        
        if email.count > 0 {
            sections.append(LocalizedString.EmailAddress.localized)
        }
        
        mobile.removeAll()
        var tempMobile = travel.contact.mobile.filter { (mbl) -> Bool in
            !mbl.value.isEmpty
        }
        
        tempMobile.sort(by: { $0.label < $1.label })
        mobile.append(contentsOf: tempMobile)
        
        if mobile.count > 0 {
            sections.append(LocalizedString.ContactNumber.localized)
        }
        if social.count > 0 {
            self.social = social
            sections.append(LocalizedString.SocialAccounts.localized)
        }
        
        if travel.address.count > 0 {
            addresses = travel.address
            sections.append(LocalizedString.Address.localized)
        }
        
        informations.removeAll()
        moreInformation.removeAll()
        if !travel.dob.isEmpty {
            if let value = AppGlobals.shared.formattedDateFromString(dateString: travel.dob, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") {
                moreInformation.append(LocalizedString.Birthday.localized)
                informations.append(value)
            }
        }
        if !travel.doa.isEmpty {
            if let value = AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") {
                moreInformation.append(LocalizedString.Anniversary.localized)
                informations.append(value)

            }
        }
        if !travel.notes.isEmpty {
            informations.append(travel.notes)
            moreInformation.append(LocalizedString.Notes.localized)
        }
        if informations.count > 0 {
            sections.append(LocalizedString.MoreInformation.localized)
        }
        passportDetails.removeAll()
        if !travel.passportNumber.isEmpty {
            passportDetails.append((travel.passportNumber))
            passportDetails.append((travel.passportCountryName))
            sections.append(LocalizedString.PassportDetails.localized)
        }
        
        if !travel.passportIssueDate.isEmpty {
            passportDetails.append(travel.passportIssueDate)
        }
        else if !travel.passportExpiryDate.isEmpty, !passportDetails.contains(travel.passportIssueDate) {
            passportDetails.append((travel.passportExpiryDate))
        }
        
        flightDetails.removeAll()
        if !travel.preferences.seat.value.isEmpty {
            flightDetails.append(travel.preferences.seat.value)
            flightPreferencesTitle.insert(LocalizedString.seatPreference.rawValue, at: 0)
//            flightDetails.append(travel.preferences.seat.value)
            sections.append(LocalizedString.FlightPreferences.localized)
        }
        
        if !travel.preferences.meal.value.isEmpty {
            flightDetails.append(travel.preferences.meal.value)
            if !sections.contains(LocalizedString.FlightPreferences.localized) {
                sections.append(LocalizedString.FlightPreferences.localized)
                flightPreferencesTitle.insert(LocalizedString.mealPreference.rawValue, at: 0)
            } else {
                flightPreferencesTitle.insert(LocalizedString.mealPreference.rawValue, at: 1)
            }
        }
        
        let frequentFlyer = travel.frequestFlyer
        if frequentFlyer.count > 0 {
            self.frequentFlyer = frequentFlyer
            if !sections.contains(LocalizedString.FlightPreferences.localized) {
                sections.append(LocalizedString.FlightPreferences.localized)
            }
        }
        
        self.profileImageHeaderView?.dividerView.isHidden = !sections.isEmpty
        tableView.reloadData()
    }
    
    func getProgressiveHeight(forProgress: CGFloat) -> CGFloat {
        let ratio: CGFloat = headerHeightToAnimate / CGFloat(0.5)
        return headerHeightToAnimate - (forProgress * ratio)
    }
    
    func createAddress(_ address : Address) -> String {
        var completeAddress = ""
        if !address.line1.isEmpty {
            completeAddress += address.line1
        }
        if !address.line2.isEmpty && !address.line1.isEmpty{
            completeAddress += "\n" + address.line2
        } else {
            completeAddress += address.line2
        }
        if !address.city.isEmpty  {
            completeAddress += "\n" + address.city
        }
        if !address.postalCode.isEmpty {
            completeAddress += "-" + address.postalCode
        }
        if !address.state.isEmpty {
            completeAddress += "\n" + address.state
        }
        if !address.countryName.isEmpty {
            completeAddress += ", " + address.countryName
        }
        return completeAddress
    }
    
}

extension ViewProfileDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.topNavView.configureFirstRightButton( normalTitle: "", selectedTitle: "")
        self.topNavView.isToShowIndicatorView = true
        self.topNavView.startActivityIndicaorLoading()
        AppFlowManager.default.moveToEditProfileVC(travelData: travelData, usingFor: self.viewModel.currentlyUsingFor)
        delay(seconds: 0.5) { [weak self] in
            self?.topNavView.stopActivityIndicaorLoading()
        }
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
            return passportDetails.count
        case LocalizedString.FlightPreferences.localized:
            if frequentFlyer.count > 0 {
                return flightDetails.count + frequentFlyer.count
            } else {
                return flightDetails.count
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
            cell.configureCell(mobile[indexPath.row].label, mobile[indexPath.row].valueWithISD.removeAllWhiteSpacesAndNewLines)
            cell.separatorView.isHidden = (indexPath.row + 1 == mobile.count) ? true : false
            return cell
        case LocalizedString.SocialAccounts.localized:
            cell.configureCell(social[indexPath.row].label, social[indexPath.row].value)
            cell.separatorView.isHidden = (indexPath.row + 1 == social.count) ? true : false
            return cell
        case LocalizedString.Address.localized:
            let address = createAddress(addresses[indexPath.row])
            cell.configureCell(addresses[indexPath.row].label, address)
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
                viewProfileMultiDetailcell.secondTitleLabel.isHidden = false
                viewProfileMultiDetailcell.separatorView.isHidden = indexPath.row >= (passportDetails.count - 1)
                return viewProfileMultiDetailcell
                
            } else {
                cell.configureCell(passportDetaitTitle[indexPath.row], passportDetails[indexPath.row])
                cell.separatorView.isHidden = indexPath.row >= (passportDetails.count - 1)
                return cell
            }
        case LocalizedString.FlightPreferences.localized:
            if flightDetails.count > indexPath.row {
                cell.configureCell(flightPreferencesTitle[indexPath.row], flightDetails[indexPath.row])
                cell.sepratorLeadingConstraint.constant = (indexPath.row < (flightDetails.count + frequentFlyer.count)-1) ? 16.0 : 0.0
                cell.separatorView.isHidden = false
                return cell
            }
            else {
                if (flightDetails.count == 1 && indexPath.row == 1) || (flightDetails.count == 2 && indexPath.row == 2) {
                    guard let viewProfileDetailFrequentcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                    fatalError("ViewProfileMultiDetailTableViewCell not found")
                    }
                    viewProfileDetailFrequentcell.configureCellForFrequentFlyer(indexPath, frequentFlyer[indexPath.row - flightDetails.count].logoUrl, frequentFlyer[indexPath.row - flightDetails.count].airlineName, frequentFlyer[indexPath.row - flightDetails.count].number,flightDetails.count)
                    return viewProfileDetailFrequentcell
                } else {
                    guard let viewProfileMultiDetailcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                        fatalError("ViewProfileMultiDetailTableViewCell not found")
                    }
                    viewProfileMultiDetailcell.secondTitleLabel.isHidden = true
                    viewProfileMultiDetailcell.configureCellForFrequentFlyer(indexPath, frequentFlyer[indexPath.row - flightDetails.count].logoUrl, frequentFlyer[indexPath.row - flightDetails.count].airlineName, frequentFlyer[indexPath.row - flightDetails.count].number,flightDetails.count)
                    
                    viewProfileMultiDetailcell.separatorLeadingConstraint.constant = (indexPath.row < (flightDetails.count + frequentFlyer.count)) ? 16.0 : 0
                    viewProfileMultiDetailcell.separatorTrailingConstraint.constant = (indexPath.row < (flightDetails.count + frequentFlyer.count)) ? 16.0 : 0
                    viewProfileMultiDetailcell.separatorView.isHidden = (indexPath.row == (flightDetails.count + frequentFlyer.count) - 1) ? false : false
                    
                    if  indexPath.row == (frequentFlyer.count + flightDetails.count) - 1 {
                        viewProfileMultiDetailcell.separatorLeadingConstraint.constant = 0.0
                        viewProfileMultiDetailcell.separatorTrailingConstraint.constant = 0.0
                    }
                    return viewProfileMultiDetailcell
                    
                }
                
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
        headerView.topDividerHeightConstraint.constant = 0.5
        headerView.headerLabel.text = sections[section].localized
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let totalSection = self.numberOfSections(in: self.tableView)
        if sections[section] != LocalizedString.FlightPreferences.localized, section == (totalSection - 1) {
            return 0.5
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let totalSection = self.numberOfSections(in: self.tableView)
        if sections[section] != LocalizedString.FlightPreferences.localized, section == (totalSection - 1) {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 0.5))
            footerView.backgroundColor = AppColors.divider.color
            return footerView
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
//        switch sections[indexPath.section] {
//        case LocalizedString.FlightPreferences.localized:
//            return false
//        default :
            return true
//        }
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            var pasteText = ""
            switch sections[indexPath.section] {
            case LocalizedString.EmailAddress.localized:
                pasteText = email[indexPath.row].value
            case LocalizedString.MoreInformation.localized:
                pasteText = informations[indexPath.row]
            case LocalizedString.ContactNumber.localized:
                 pasteText = mobile[indexPath.row].valueWithISD.removeAllWhiteSpacesAndNewLines
            case LocalizedString.SocialAccounts.localized:
                pasteText = social[indexPath.row].value
            case LocalizedString.Address.localized:
                pasteText = createAddress(addresses[indexPath.row])
            case LocalizedString.PassportDetails.localized:
                if indexPath.row >= 2 {
                } else {
                    pasteText = passportDetails[indexPath.row]
                }
            case LocalizedString.FlightPreferences.localized:
                if flightDetails.count > indexPath.row {
                    pasteText = flightDetails[indexPath.row]
                }
                else {
                    if (flightDetails.count == 1 && indexPath.row == 1) || (flightDetails.count == 2 && indexPath.row == 2) {
                        pasteText = "\(frequentFlyer[indexPath.row - flightDetails.count].airlineName)\n\(frequentFlyer[indexPath.row - flightDetails.count].number)"
                    } else {
                        pasteText = "\(frequentFlyer[indexPath.row - flightDetails.count].airlineName)\n\(frequentFlyer[indexPath.row - flightDetails.count].number)"
                    }
                    
                }
            default:
                pasteText = ""
            }
            let pasteboard = UIPasteboard.general
            pasteboard.string = pasteText
        }
    }
    /*
     https://stackoverflow.com/questions/2487844/simple-way-to-show-the-copy-popup-on-uitableviewcells-like-the-address-book-ap/2488237#2488237
     */
}

// MARK: - MXParallaxHeaderDelegate methods

extension ViewProfileDetailVC: MXParallaxHeaderDelegate {
    @objc func updateForParallexProgress() {
        
        let prallexProgress = self.tableView.parallaxHeader.progress
        
        printDebug("progress %f \(prallexProgress)")
        
        if 0.6...1.0 ~= prallexProgress {
            profileImageHeaderView?.profileImageViewHeightConstraint.constant = 127.0 * prallexProgress
        }

        if prallexProgress <= 0.7 {
            if isNavBarHidden {
                       self.statusBarStyle = .lightContent
                       self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                           self?.topNavView.firstRightButton.isSelected = false
                           self?.topNavView.leftButton.isSelected = false
                           self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                           self?.topNavView.navTitleLabel.text = ""
                        self?.topNavView.backView.backgroundColor = .clear //AppColors.themeWhite
                        self?.topNavView.dividerView.isHidden = true
                       }
            } else {
                self.statusBarStyle = .darkContent
                           self.topNavView.animateBackView(isHidden: false) { [weak self](isDone) in
                               self?.topNavView.firstRightButton.isSelected = true
                               self?.topNavView.leftButton.isSelected = true
                               self?.topNavView.leftButton.tintColor = AppColors.themeGreen
                               self?.topNavView.navTitleLabel.text = self?.getUpdatedTitle()
                            self?.topNavView.dividerView.isHidden = false
                           }
            }
        } else {
            self.statusBarStyle = .lightContent
            self.topNavView.animateBackView(isHidden: true) { [weak self](isDone) in
                self?.topNavView.firstRightButton.isSelected = false
                self?.topNavView.leftButton.isSelected = false
                self?.topNavView.leftButton.tintColor = AppColors.themeWhite
                self?.topNavView.navTitleLabel.text = ""
                self?.topNavView.backView.backgroundColor = .clear //AppColors.themeWhite
                self?.topNavView.dividerView.isHidden = true
            }
        }
        self.isNavBarHidden =  false
        profileImageHeaderView?.layoutIfNeeded()
        profileImageHeaderView?.doInitialSetup()
    }
    
    func getUpdatedTitle() -> String {
        var updatedTitle = self.profileImageHeaderView?.userNameLabel.text ?? ""
        if updatedTitle.count > 24 {
            updatedTitle = updatedTitle.substring(from: 0, to: 8) + "..." +  updatedTitle.substring(from: updatedTitle.count - 8, to: updatedTitle.count)
        }
        return updatedTitle
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.updateForParallexProgress), with: nil, afterDelay: 0.05)
        //        self.updateForParallexProgress()
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
    
    func willGetDetail(_ isShowLoader: Bool = false) {
        self.profileImageHeaderView?.startLoading()
        if isShowLoader {
            AppGlobals.shared.startLoading(loaderBgColor: AppColors.clear)
        }
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        self.profileImageHeaderView?.stopLoading()
        AppGlobals.shared.stopLoading()
        travelData = data
        setUpDataFromApi()
        self.sendDataChangedNotification(data: ATNotification.profileChanged)
    }
    
    func getFail(errors: ErrorCodes) {
        self.profileImageHeaderView?.stopLoading()
        AppGlobals.shared.stopLoading()
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
    }
}
